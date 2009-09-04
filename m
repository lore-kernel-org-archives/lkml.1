Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZIDQDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZIDQDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbZIDQDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:03:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32947 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbZIDQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:03:21 -0400
Date: Fri, 4 Sep 2009 18:03:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] VT: Add a boot option to disable cursor on boot
Message-ID: <20090904180302.6561fabf@lxorguk.ukuu.org.uk>
In-Reply-To: <1252079289-5383-1-git-send-email-mjg@redhat.com>
References: <1252079289-5383-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Sep 2009 11:48:09 -0400
Matthew Garrett <mjg@redhat.com> wrote:

> The VT code currently enables a visible cursor on boot. This is a fairly
> unnecessary visual distraction for setups which boot to a splash screen
> before going directly into X, so add a boot option (vt.hide_boot_cursor=1)
> that doesn't enable the cursor for initial VT setup. VT resets and any
> later VT creation will leave the cursor turned on, as before.

Seems odd to me - why can't the splash screen app in initrd just issue
the call to turn off the cursor - or is this splash screen coming from
something else ?

Either way the implementation in your patch is butt-ugly adding an extra
special case all over the place.

IMHO
- If the splash screen is kernel based then the splash screen module
  needs to be able to ask the vt driver itself
- If not then the user space can use ioctls like everyone else (see
  setterm)
- It should be implemented without adding an extra condition to a pile of
  ifs (or the condition mess at least become a single cursor_visible_p())

Alan
