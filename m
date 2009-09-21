Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZIUJas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZIUJas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZIUJar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:30:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbZIUJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:30:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] remove duplicate asm/mman.h files
Date: Mon, 21 Sep 2009 11:30:26 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
       ebmunson@us.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-ia64@vger.kernel.org
References: <cover.1251197514.git.ebmunson@us.ibm.com> <200909211031.25369.arnd@arndb.de> <alpine.DEB.1.00.0909210208180.16086@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909210208180.16086@chino.kir.corp.google.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909211130.26377.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18gAorIpOj7WzWcW8zJNaHb0sGgKz4SVygBk9a
 n9TVeI6bUdXyfkXUYxhshIjMuieqWjO8JybC+FENU7SdjwVHqZ
 1Op6VygII3xdffhCTNZFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 September 2009, David Rientjes wrote:
> > I tried not to change the ABI in any way in my patch, and there is
> > a theoretical possibility that some user space program on ia64 currently
> > depends on that definition.
> > 
> 
> I don't buy that as justification, if some userspace program uses it based 
> on the false belief that it actually does what it says, it's probably 
> better to break their build than perpetuating the lie that it's different 
> than ~MAP_GROWSDOWN.

It's more a matter of principle of my patches. I try to strictly separate
patches that move code around (like the one I sent) from those that
change contents (like yours, or the one before that adds MAP_STACK and
MAP_HUGETLB).

Removing a definition from an exported header file either requires
specific knowledge about why it is there to start with, or more
research on the topic than I wanted to do. For instance, a theoretical
program might have a helper function correctly doing

void *xmmap(void *addr, size_t length, int prot, int flags,
                  int fd, off_t offset)
{
	if (flags & MAP_GROWSUP) { /* MAP_GROWSUP is not supported */
		errno = -EINVAL;
		return MAP_FAILED;
	}

	return mmap(addr, length, prot, flags, fd, offset);
}

Of course, such a program would only work on ia64 currently, so
it should be safe to make ia64 behave like the other architectures
in this regard.

> ia64: remove definition for MAP_GROWSUP
> 
> MAP_GROWSUP is unused.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
