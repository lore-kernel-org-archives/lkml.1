Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXB1RJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXB1RJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXB1RJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:09:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34311 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989AbXB1RJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:09:03 -0500
Date: Wed, 28 Feb 2007 09:09:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Jiri Kosina wrote:
>
> The diffstat looks larger because the usbhid code is moved from 
> USB-specific directory to HID-specific directory

No. The diffstat looks huge because you moved "hid_blacklist" into a 
header file, and that is a big enough change that git won't consider the 
rename to be just a rename any more (you basically moved the old 
usbdrivers/usb/input/hid-core.c file into *two* files: hid-core.c and 
usbhid.h).

Why do that? It now gets included INTO EVERY DAMN FILE that includes 
<usbhid.h>, since that one now has that

	static const struct hid_blacklist

definition in it. Yet *nothing* wants it, except for the one C file that 
it used to be in.

No way in hell will I include this kind of crap without major explanations 
for why the "crap" is not crap. And quite frankly, I don't think such 
explanations exist.

I'm also not going to pull it if you just add a new commit to undo the 
idiocy. That thing needs to be totally re-done, as far as I'm concerned. I 
don't want to touch anything that has EVER even *seen* anything that 
stupid.

Yes, I'm grumpy. I don't like big changes at this stage, and if they are 
also STUPID big changes, as this seems to be, I refuse to pull them 
entirely.

		Linus
