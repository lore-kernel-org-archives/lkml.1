Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYEDVL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYEDVL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbYEDVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:11:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:64744 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019AbYEDVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:11:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 30/56] microblaze_v2: includes SHM*, msgbuf
Date: Sun, 4 May 2008 23:10:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu> <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
In-Reply-To: <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805042310.34042.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0zV7serrXh2gt0ZQyZwocznAZ4TkTfX5GPXI
 iS8dHhvWbjvSY0PrOgiwE0mFkRtZZAsh3Bz7p9SiSf83WunamI
 20HSuHmkIalIfqORVkJhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:

>  include/asm-microblaze/msgbuf.h   |   41 +++++++++++++++++++++++++++++
>  include/asm-microblaze/shmbuf.h   |   52 +++++++++++++++++++++++++++++++++++++
>  include/asm-microblaze/shmparam.h |   16 +++++++++++
>  3 files changed, 109 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-microblaze/msgbuf.h
>  create mode 100644 include/asm-microblaze/shmbuf.h
>  create mode 100644 include/asm-microblaze/shmparam.h

Along with cleaning up the syscall interface, you should create asm-generic
versions of these files, ipcbuf.h and sembuf.h belong in the same category
(sysv IPC).

Unfortunately, most architectures have slightly different versions of them,
few of them really getting it right.
The version you have copied to microblaze is correct for little-endian
32 bit architectures, but not for big-endian architectures. The only
big-endian architectures that correctly implement padding are parisc,
powerpc, sparc, and the only one that gets 32 bit emulation right is
parisc (which, btw is a common scheme: if you want to know how to do
it, look at the parisc code).

I suppose it doesn't really matter much now, because SysV IPC is not
used a lot any more, and people have learned to live with the ill-defined
data structures. Most architectures have made the same mistake by
blindly copying the i386 version, so I'd suggest you take the version
you have and move that to asm-generic/{msg,shm,sem,ipc}buf.h, and
asm-generic/shmparam.h, so that every architecture using a copy of the
i386 headers can move to the generic one.

	Arnd <><
