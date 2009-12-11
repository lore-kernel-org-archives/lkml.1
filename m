Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbZLKV3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbZLKV3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759184AbZLKV3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:29:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760598AbZLKV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:29:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 8/9] Documentation: Fix invalid rcu assumptions
Date: Fri, 11 Dec 2009 21:28:25 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc6-00266-g3420e74; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
References: <20091210001308.247025548@linutronix.de> <20091210004703.308396881@linutronix.de>
In-Reply-To: <20091210004703.308396881@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112128.25954.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18THUSg0GfnDXf6uBgchfAsuWIG2jHR40anfdk
 LCbGJtU75Q6QG1zO29KQvkuLj6ilQ9d3LhsVG6yk8rxeJ3/4Om
 StzSi5d9S5jstZR/u9Bbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009 00:53:26 Thomas Gleixner wrote:
> Index: linux-2.6-tip/Documentation/credentials.txt
> ===================================================================
> --- linux-2.6-tip.orig/Documentation/credentials.txt
> +++ linux-2.6-tip/Documentation/credentials.txt
> @@ -408,9 +408,6 @@ This should be used inside the RCU read 
>                 ...
>         }
>  
> -A function need not get RCU read lock to use __task_cred() if it is holding a
> -spinlock at the time as this implicitly holds the RCU read lock.
> -
>  Should it be necessary to hold another task's credentials for a long period of
>  time, and possibly to sleep whilst doing so, then the caller should get a
>  reference on them using:

How about changing the documentation to explain why you can't just use a spinlock
or local_irq_disable instead of rcu_read_lock? You explained it well in your
[patch 0/9], but that part had not occurred to me yet and having it in the kernel
sources might prevent more people from getting it wrong in the future.

	Arnd
