Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbXB1RY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbXB1RY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXB1RY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:24:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:43037 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751386AbXB1RYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:24:25 -0500
Date: Wed, 28 Feb 2007 18:25:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Linus Torvalds wrote:

> > The diffstat looks larger because the usbhid code is moved from 
> > USB-specific directory to HID-specific directory
> No. The diffstat looks huge because you moved "hid_blacklist" into a 
> header file, and that is a big enough change that git won't consider the 
> rename to be just a rename any more (you basically moved the old 
> usbdrivers/usb/input/hid-core.c file into *two* files: hid-core.c and 
> usbhid.h).

Yes, but was done by two separate commits, diffstat -M for 
3d5af52d0997d545995d8747c8057be5dee49b14 shows hid-core.c as a 100% 
rename, but later commit b41ea57c01a1943ab36af0017cfc1329815af9ce splits 
it, so in cummulative diffstat it doesn't show it as a rename.

> Why do that? It now gets included INTO EVERY DAMN FILE that includes 
> <usbhid.h>, since that one now has that
> 	static const struct hid_blacklist
> definition in it. Yet *nothing* wants it, except for the one C file that 
> it used to be in.

You're right that usbhid.h is not a best place for it. The thing is that 
hid_blacklist[] and related things just badly needs cleanup - it has been 
for quite a long time placed on a really random place in the middle of a 
.c file. In addition to that, the corresponding #defines are scatthered 
around, interleaved with functions (see for example where 
USB_VENDOR_ID_PANJIT and USB_VENDOR_ID_TURBOX defines are).

> I'm also not going to pull it if you just add a new commit to undo the 
> idiocy. That thing needs to be totally re-done, as far as I'm concerned. I 
> don't want to touch anything that has EVER even *seen* anything that 
> stupid.

This IMHO just needs cleanup. Will you accept creating a separate header 
file solely for purposes of this blacklist and related defines?

Otherwise I will just drop this cleanup, but I still think that the 
current situation is horrible.

> Yes, I'm grumpy. I don't like big changes at this stage, and if they are 
> also STUPID big changes, as this seems to be, I refuse to pull them 
> entirely.

Are you also opposed to just the code movement? There are some bugfixes I 
think that really need merging, so just to know what would be acceptable 
for you at the time being.

Thanks,

-- 
Jiri Kosina
