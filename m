Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZGCPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZGCPDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZGCPDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:03:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZGCPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:03:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: mmap syscall problem
Date: Fri, 3 Jul 2009 17:02:52 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-10-generic; KDE/4.2.95; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
References: <4A4DFB77.1080700@petalogix.com>
In-Reply-To: <4A4DFB77.1080700@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907031702.52612.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+54oem0HDMKYwSBM6KiWuzPTfZkQNWytuDkVX
 x6WtV4m5R+loe9H0WKqk4+BBybDFTBlU8qct7BrA5Gu6NxKoa5
 qgKeSH06H5XEfXCnwNE+gm6eqh40Gwe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Michal Simek wrote:

> I am trying to solve problem with mmap syscall on Microblaze which I have.
> I am running mmap01 test program from LTP. In attachment is hacked
> version and inline version is below too.

Does this happen on microblaze-mmu or microblaze-nommu, or both?
The mmap code for the two is very different.

What file system is backing the temporary file?

For -nommu, there are a number of ristrictions from
Documentation/nommu-mmap.txt, in particular, MAP_FIXED is
forbidden, as is PROT_WRITE with regular files. 
 
> Arnd: Anyway maybe worth to move sys_mmap2 to any generic location. What
> do you think?

Yes, that would be good. I actually have a patch for that somewhere in
my playground repository, but it build-breaks some architectures in the
current state. I'm planning to fix that (and do the same for execve
and maybe some of the other remaining arch specific syscalls) at some
point.

	Arnd <><
