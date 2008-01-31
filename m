Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYAaAco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYAaAco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYAaAch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:32:37 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37907 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYAaAcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:32:36 -0500
Date: Thu, 31 Jan 2008 02:33:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux390@de.ibm.com
Subject: x86 arch updates also broke s390
Message-ID: <20080131003310.GW29368@does.not.exist>
References: <20080130011550.GA31853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080130011550.GA31853@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<--  snip  -->

...
  CC      arch/s390/kernel/asm-offsets.s
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/s390/kernel/asm-offsets.c:7:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h: In function 'spin_needbreak':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:1931: error: implicit declaration of function '__raw_spin_is_contended'
make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1

<--  snip  -->


Guilty commit:

Commit: 95c354fe9f7d6decc08a92aa26eb233ecc2155bf 
Author: Nick Piggin <npiggin@suse.de> Wed, 30 Jan 2008 13:31:20 +0100 

    spinlock: lockbreak cleanup
    
    The break_lock data structure and code for spinlocks is quite nasty.
    Not only does it double the size of a spinlock but it changes locking to
    a potentially less optimal trylock.
    
    Put all of that under CONFIG_GENERIC_LOCKBREAK, and introduce a
    __raw_spin_is_contended that uses the lock data itself to determine whether
    there are waiters on the lock, to be used if CONFIG_GENERIC_LOCKBREAK is
    not set.
    
    Rename need_lockbreak to spin_needbreak, make it use spin_is_contended to
    decouple it from the spinlock implementation, and make it typesafe (rwlocks
    do not have any need_lockbreak sites -- why do they even get bloated up
    with that break_lock then?).
    
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>




cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

