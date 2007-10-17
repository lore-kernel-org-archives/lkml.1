Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbXJQJDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbXJQJDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXJQJDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:03:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbXJQJDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:03:12 -0400
Date: Wed, 17 Oct 2007 02:02:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: 2.6.23-mm1
Message-Id: <20071017020225.7c4d665c.akpm@linux-foundation.org>
In-Reply-To: <20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 16:01:01 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I noticed 32bit binary on x86_64 behavior is changed on 2.6.23-mm1.
> 
> This is a result of pmap after process returns -ENOMEM.(see attached program)
> == on 2.6.23 ==
> errno 12
> 3531:   ./malloc
> 0000000000001000   6272K -----    [ anon ]
> 0000000000621000    100K r-x--  /lib/ld-2.5.so
> 000000000063a000      4K r----  /lib/ld-2.5.so
> 000000000063b000      4K rw---  /lib/ld-2.5.so
> 000000000063c000      8K -----    [ anon ]
> 000000000063e000   1244K r-x--  /lib/libc-2.5.so
> 0000000000775000      8K r----  /lib/libc-2.5.so
> 0000000000777000      4K rw---  /lib/libc-2.5.so
> 0000000000778000     12K rw---    [ anon ]
> 000000000077b000 123700K -----    [ anon ]
> 0000000008048000      4K r-x--  /home/kamezawa/malloc
> 0000000008049000      4K rw---  /home/kamezawa/malloc
> 000000000804a000 3929824K -----    [ anon ]
> 00000000f7f02000      8K rw---    [ anon ]
> 00000000f7f04000    100K -----    [ anon ]
> 00000000f7f1d000      4K rw---    [ anon ]
> 00000000f7f1e000 131812K -----    [ anon ]
> 00000000fffd7000     84K rw---    [ stack ]
> 00000000fffec000     72K -----    [ anon ]
> 00000000ffffe000      4K r-x--    [ anon ]
>  total          4193272K
> ==
> 
> == on 2.6.23-mm1==
> errno 12
> 3504:   ./malloc
> 0000000000621000    100K r-x--  /lib/ld-2.5.so
> 000000000063a000      4K r----  /lib/ld-2.5.so
> 000000000063b000      4K rw---  /lib/ld-2.5.so
> 000000000063e000   1244K r-x--  /lib/libc-2.5.so
> 0000000000775000      8K r----  /lib/libc-2.5.so
> 0000000000777000      4K rw---  /lib/libc-2.5.so
> 0000000000778000     12K rw---    [ anon ]
> 0000000008048000      4K r-x--  /home/kamezawa/malloc
> 0000000008049000      4K rw---  /home/kamezawa/malloc
> 0000000055555000      4K rw---    [ anon ]
> 0000000055556000    100K -----    [ anon ]
> 000000005556f000      8K rw---    [ anon ]
> 0000000055671000 2789016K -----    [ anon ]
> 00000000ffa17000     84K rw---    [ stack ]
> 00000000ffa2c000   5960K -----    [ anon ]
> 00000000ffffe000      4K r-x--    [ anon ]
>  total          2796560K
> ==

So it only managed to allocate half as much virtual memory?  Lovely.
Thanks for the test case.

> Maybe get_unmapped_area() had some change.
> Is this intended ?

It had better not be.

It is due to pie-executable-randomization.patch.  That patch has been an
ongoing source of trouble.  I'll drop it.  Again.  Guys, please don't resend
it until it actually works.

