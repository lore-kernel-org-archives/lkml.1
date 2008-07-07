Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYGGGfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYGGGfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYGGGfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:35:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYGGGfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:35:31 -0400
Date: Mon, 7 Jul 2008 08:35:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, linux-mm@kvack.org
Subject: Re: next-0704: WARNING: at kernel/sched.c:4254 add_preempt_count;
	PANIC
Message-ID: <20080707063519.GE23583@elte.hu>
References: <487159DA.708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487159DA.708@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Hi
> 
> WARNING: at kernel/sched.c:4254 add_preempt_count+0x61/0x63()
> Modules linked in: i2c_nforce2
> Pid: 3620, comm: rtorrent Not tainted 2.6.26-rc8-next-20080704 #5

this warning is what triggers:

 #ifdef CONFIG_DEBUG_PREEMPT
         /*
          * Underflow?
          */
         if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
                 return;

i.e. preempt counter underflow. That can happen either due to unbalanced 
preempt_disable()/preempt_enable() pairs, or can happen due to stack 
overflow/corruption.

	Ingo
