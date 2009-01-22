Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZAVVqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZAVVqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZAVVqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:46:38 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:54436 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZAVVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:46:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:message-id:date:subject:from:to:user-agent
         :mime-version:content-type:content-transfer-encoding:x-priority
         :importance;
        b=cej1qnRca8Q26s4heaowxr516fd2gBwRN81TLUEi4fLByc1wMxlVCuIQ+i+oTEy8My
         P6MWI3Tt8M4/QhHsLEkZhQa1iK8k/fO6MKnrk4cadfr5qi0eZpaSndGK9CsdhwwosmHP
         jrBh8KsZvGqDOQ6QGKxsP3iGi04abljVpY00M=
Message-ID: <6cc6e376b34fd371cf946c1660c97f6e.squirrel@localhost>
Date: Thu, 22 Jan 2009 15:46:28 -0600 (CST)
Subject: Odd behavior in musb_hdrc OTG if gadget drivers are modules
From: david.hagood@gmail.com
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.16-1.fc10
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've spend the day tracking down a weird behavior on a Beagleboard with
2.6.29-rc2-omap1.

If you select the mode for the musb to operate in OnTheGo mode
(CONFIG_USB_MUSB_OTG), and if you compile the gadget drivers as modules,
the the USB port will NOT be brought up at system boot, even if it has a
USB mini-A cable plugged in (and thus should be in host mode, not gadget
mode).

If you then modprobe an appropriate gadget driver, then the interface will
be brought up in host mode.

If you DON'T modprobe a gadget driver, AND you attempt to force the port
to host mode by
  echo host > /sys/devices/platform/musb_hdrc/mode

Then we get a kernel page fault trying to change modes, even though we are
changing to host mode, which should be valid.

It seems to me that either the port should be brought up in host mode if
no gadget drivers are loaded, and an attempt to switch to gadget mode
should fail if no driver is loaded, OR there should be a config options to
set what the default gadget driver is in the absence of one being loaded
by the system.


