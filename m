Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYEDThj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYEDThj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYEDTh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:37:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:56098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbYEDTh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:37:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: microblaze syscall list
Date: Sun, 4 May 2008 21:37:13 +0200
User-Agent: KMail/1.9.9
Cc: microblaze-uclinux@itee.uq.edu.au, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200805032357.41043.arnd@arndb.de> <481D7DF7.3000909@seznam.cz>
In-Reply-To: <481D7DF7.3000909@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805042137.17383.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18MFGyi4pdOez0rI21a62lOzWlQZ/U40ZT2d+B
 2tI3AGSjdvfsakIV+n+lz8Y+5YNs5p4D3kiorKbmzbqL7b0yDi
 BeEognSfC7HNmgZbsqIXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, Michal Simek wrote:

> > mremap is a duplicate, you only need it once ;-)
> 
> There are mixed mmu and nommu version - brk, munmap, mrepap are in both version
> but they take from different files.

That doesn't matter as the kernel is only ever built with one of the
two files. My point was just that you should have only one entry
in the syscall table if you generate it from your list.
 
> > right. sys_pipe and sys_mmap2 should probably go to fs/pipe.c and mm/mmap.c, but
> > that does not need to be your worry right now, it's not part of the ABI.
> 
> YES. sys_pipe was remove from all arch today. Patches from Uli. I'll remove
> sys_pipe from our sys_microblaze.c.

Ah, cool. I guess this leaves sys_mmap2, which we'll take care of eventually.
 
> Here is updated syscall table.

Thanks, looks good. I'd love to get a second opinion on the list though,
it's quite likely that I made a mistake somewhere.

Just three more calls I found:

> ok	.long sys_unlinkat
> ok	.long sys_unlink

> ok	.long sys_linkat
> ok	.long sys_link

> ok	.long sys_chown
> ok	.long sys_fchownat

For all of these, you only need the *at variant, afaict.

	Arnd <><
