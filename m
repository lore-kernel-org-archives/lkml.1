Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZGFIF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZGFIF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZGFIFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:05:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbZGFIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:05:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: mmap syscall problem
Date: Mon, 6 Jul 2009 10:05:35 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
References: <4A4DFB77.1080700@petalogix.com> <200907031702.52612.arnd@arndb.de> <4A519A70.50801@petalogix.com>
In-Reply-To: <4A519A70.50801@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907061005.36094.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX190eZNf4rh6AUI6S609CS7KvCmLXBNrXloTDvq
 794jyc5Ohi3qFWH/viWDx8EIRUtiZXLulh3X+Z26SR8ld6FXtE
 +tTVH0IY5gRT/I3xA5Etg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009, Michal Simek wrote:
> > Does this happen on microblaze-mmu or microblaze-nommu, or both?
> > The mmap code for the two is very different.
> >   
> For MMU code.

Could this be a cache-aliasing problem? If your cache is 'virtually-indexed'
(most architectures are 'physically-indexed'), the kernel may have written
into different parts of the D-cache than what the user space is reading
from. If you have a write-through cache, that can explain why you only
see the stale data at the beginning of the page -- the cache controller
is still busy writing back the data when you start reading it from
DRAM through the cache alias.

If this is your problem, then you need to implement flush_dcache_page()
and other functions that maintain cache consistency. See
Documentation/cachetlb.txt and http://www.linuxjournal.com/article/7105

	Arnd <><
