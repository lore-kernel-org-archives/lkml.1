Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbZIRXkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbZIRXkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 19:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZIRXkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 19:40:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbZIRXkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 19:40:18 -0400
Date: Fri, 18 Sep 2009 16:38:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Wu Fei <at.wufei@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, arjan@infradead.org,
       jeremy@goop.org, mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
 kthreadd_task_init_done
In-Reply-To: <20090918232215.GA25517@redhat.com>
Message-ID: <alpine.LFD.2.01.0909181632500.4950@localhost.localdomain>
References: <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org> <20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu> <20090918163241.GA8556@desktop> <20090918185425.GA16620@redhat.com>
 <alpine.LFD.2.01.0909181217270.4950@localhost.localdomain> <20090918211218.GA19351@redhat.com> <alpine.LFD.2.01.0909181504400.4950@localhost.localdomain> <20090918232215.GA25517@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 19 Sep 2009, Oleg Nesterov wrote:
>
> On 09/18, Linus Torvalds wrote:
> >
> > As to why pid == 0 wouldn't work, I don't know, but I'll take your word
> > for it.
> 
> Say, admin wants to renice kthreadd or change its affinity. And we can't
> show kthread in /proc if its pid is 0.

Ok, so it's a "that's not good" kind of situation, rather than a "it 
wouldn't work" one. Fair enough.

Of course, another way to do this would be to simply use CLONE_STOPPED to 
create the 'init' task first, but not wake it up - and then wake it up 
only after kthreadd exists.

I'm sure there are other things we could do ;)

		Linus
