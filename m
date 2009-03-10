Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZCJUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZCJUDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZCJUC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:02:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:51974 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755667AbZCJUC5 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:02:57 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19ui+hRO3duX0BjEv0IHgTWJn0x+N2HDDBjK6Brgo
	VBHxYhJWToKCb9
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
Date: Tue, 10 Mar 2009 21:02:48 +0100
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <49AF30EC.8010205@lougher.demon.co.uk> <200903092239.13078.s.L-H@gmx.de> <49B5CCB7.5030404@lougher.demon.co.uk>
In-Reply-To: <49B5CCB7.5030404@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903102102.50584.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Dienstag, 10. März 2009, Phillip Lougher wrote:
> Stefan Lippers-Hollmann wrote:
> 
> > 
> > This patch seems to break squashfs for me on i386 and amd64. 
> > 
> > Test environment is a squashed filesystem image (live CD image, but also 
> > tested manually with a loop mounted iso9660 and loop mounted squashfs; 
> > kernel 2.6.29-rc7-git2). The squashfs image has been created with 
> > squashfs-tools CVS[1] as of today (latest commit 2009-03-03).
> > 
> 
> Hi,
> 
> Can you send me a filesystem (or link to one) which exhibits this?  Zlib 
> is obviously showing unexpected behaviour...

http://sidux.com/slh/squashfs/sidux-snapshot-minimal-i386-200903101824.iso [104 MB]

MD5:
03475b9793134f48306fe2ba7f26ce7c *sidux-snapshot-minimal-i386-200903101824.iso

SHA256:
6ff9ec65102af8e2277a0ec30e8db13be2313ef64c9a3a3b5febaafab37cf00f *sidux-snapshot-minimal-i386-200903101824.iso

The squashfs image is stored inside the ISO9660 container as 
"sidux/sidux.686", it is bootable and the installed kernel (2.6.29-rc7-git3
+ aufs2, it's required for the live system, but I have checked that it is 
also reproducable with plain linux-2.6.git and without any patches, outside
of a live environment) exposes this problem.

Sources for all software installed inside the squashfs image is available 
at:
	http://sidux.com/slh/squashfs/sidux-snapshot-minimal-i386-200903101824-source/

The (Debian-) packaged kernel source as:
	dget http://sidux.com/slh/squashfs/sidux-snapshot-minimal-i386-200903101824-source/linux-sidux-2.6_2.6.29~rc7-1~git3.slh.0.dsc [67 MB]
and as plain tarball with all patches pre-applied:
	http://sidux.com/slh/squashfs/linux-source-sidux-2.6.29-rc7.tar.bz2 [51 MB]

which consists of the following sources/ patches:
	http://eu.kernel.org/pub/linux/kernel/v2.6/linux-2.6.28.tar.bz2 [64 MB]
	http://eu.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.29-rc7.bz2 [12 MB]
	http://eu.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.29-rc7-git3.bz2 [60 KB]

and required for the live CD, but reproducable without these:
	http://svn.berlios.de/svnroot/repos/fullstory/linux-sidux-2.6/trunk/debian/patches/debian/version.patch [4 KB]
	http://svn.berlios.de/svnroot/repos/fullstory/linux-sidux-2.6/trunk/debian/patches/debian/kernelvariables.patch [4 KB]
	http://svn.berlios.de/svnroot/repos/fullstory/linux-sidux-2.6/trunk/debian/patches/debian/doc-build-parallel.patch [4 KB]
	http://svn.berlios.de/svnroot/repos/fullstory/linux-sidux-2.6/trunk/debian/patches/debian/scripts-kconfig-reportoldconfig.patch [12 KB]
	http://svn.berlios.de/svnroot/repos/fullstory/linux-sidux-2.6/trunk/debian/patches/features/aufs2-20090309.diff [632 KB]

used Kernel config:
	http://sidux.com/slh/squashfs/config-2.6.29-rc7-sidux-686 [96 KB]

> Thanks
> 
> Phillip

Thank you a lot for your efforts, I'm now going to test Geert 
Uytterhoeven's proposed patch and will report back.

Regards
	Stefan Lippers-Hollmann
