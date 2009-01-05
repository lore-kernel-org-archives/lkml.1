Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZAENl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZAENl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZAENlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:41:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:2510 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZAENlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=j4E0aL50fJWPlpIxFh7cDVvwPdOEzX1NHa5IF5bGRaJP40h/P6YFuaDLxTobakKG1G
         iuj916EVAicCTHm8qyWCQpWSqbXfulYMziH3HTHL+Xi8eQSdg/nnxznjz/FHxSxFuitc
         93y16e/bSBq1ib9ENnwBpScZWTefR7fwKbg34=
Message-ID: <49620DF7.9040006@gmail.com>
Date: Mon, 05 Jan 2009 14:41:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Brownell <dbrownell@users.sourceforge.net>
CC: USB list <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: quirk_usb_disable_ehci takes 2x 1.5s on boot
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know since which moment (maybe I changed something in bios, but usb
legacy kbd was ever enabled), but quirk_usb_disable_ehci takes for both of my
ehci controllers 1.5 s.

More precisely, the time is spent in
pci_write_config_byte(pdev, offset + 3, 1);
by
outb((u8)value, 0xCFC + (reg & 3));
from pci_conf1_write deep in the callstack.

Is there any workaround known or something. Turning legacy usb off is not an
option, I want to control grub.

Thanks.
