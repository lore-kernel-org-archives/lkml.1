Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYGIH7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYGIH7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYGIH71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:59:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:46915 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751013AbYGIH70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:59:26 -0400
Date: Wed, 9 Jul 2008 09:59:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>, Jiri Slaby <jslaby@suse.cz>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Pascal Terjan <pterjan@mandriva.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 8 (HID)
In-Reply-To: <20080708111649.e61b19bc.randy.dunlap@oracle.com>
Message-ID: <alpine.LNX.1.10.0807090954480.25171@jikos.suse.cz>
References: <20080708192251.3275d283.sfr@canb.auug.org.au> <20080708111649.e61b19bc.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Randy Dunlap wrote:

> drivers/built-in.o: In function `usb_kbd_probe':
> usbkbd.c:(.text+0x1457c9): undefined reference to `usbhid_lookup_quirk'
> drivers/built-in.o: In function `usb_mouse_probe':
> usbmouse.c:(.text+0x14603c): undefined reference to `usbhid_lookup_quirk'
> make[1]: *** [.tmp_vmlinux1] Error 1

This got introduced by Jiri's

 	HID: fix quirk handling in usbmouse/kbd

Added to CC (and added also Pascal).

The dependency of usbkbd/usbmouse on usbhid is strange anyway. I'd 
probably remove the whole quirk lookup thing from usbkbd/usbmouse drivers. 
They introduce this ugly dependency, which is not worth it I guess. Also 
usbkbd/usbmouse drivers are not needed in the vast majority of cases 
anyway, and they shouldn't be loaded in standard configurations at all.

-- 
Jiri Kosina
SUSE Labs
