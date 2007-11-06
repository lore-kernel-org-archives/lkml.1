Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbXKFBTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbXKFBTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbXKFBT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:19:27 -0500
Received: from gw.goop.org ([64.81.55.164]:41829 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514AbXKFBT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:19:26 -0500
Message-ID: <472FC0F3.10102@goop.org>
Date: Mon, 05 Nov 2007 17:18:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org> <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com> <472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org> <472F85F2.6040501@zytor.com> <472FBC83.5060509@goop.org> <472FBF40.1010300@zytor.com>
In-Reply-To: <472FBF40.1010300@zytor.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yes; specifically, boot_params.hdr.hardware_subarch == 0 (as opposed
> to compile-time subarchitectures, like Voyager, which still boots the
> same way as far as I know.)

Yes, though it would be nice to use this mechanism to deal with voyager
booting too, so that it can be normalized as a pvop backend rather than
a separate build target.

> It would definitely be good to document what other values in this
> field changes, of course.

Yep.

> Specifically, with this bit set the decompression code won't touch the
> segment registers at all, and it's up to the caller to have all code
> and data segments set up with suitable descriptors.  The kernel will
> still try to install its own GDT when the kernel proper starts; this
> becomes a hardware_subarch issue.

Yes, the "setup proper kernel gdt" is part of the hwsubarch-specific
startup code.

Another thing it would be nice to add is an elf-note-like notion so that
the kernel can export arbitrary key/value data to the bootloader (ie,
the converse of the bootloader->kernel value list).  Xen currently does
this via ELF notes, but any semanically equivalent mechanism would do. 
It's probably simpler than trying to work out how to mush bzimage and
ELF together.

    J
