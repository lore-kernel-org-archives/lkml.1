Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZGJPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZGJPRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZGJPRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:17:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57254 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZGJPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:17:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] sched: Drop the need_resched() loop from cond_resched()
Date: Fri, 10 Jul 2009 17:17:38 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.95; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907101717.39460.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/B+aF0AU5Vif7Qh2BhoKnArc+E9ThezoB7pr6
 l1X/3Nnc/TT8KJBZ/9n2LWVi+PSVelQmO4UmrxgwcswY3Ytu7O
 U6v5b1VkqAMfUd1V75/jA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, Frederic Weisbecker wrote:
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6613,11 +6613,9 @@ static void __cond_resched(void)
>          * PREEMPT_ACTIVE, which could trigger a second
>          * cond_resched() call.
>          */
> -       do {
> -               add_preempt_count(PREEMPT_ACTIVE);
> -               schedule();
> -               sub_preempt_count(PREEMPT_ACTIVE);
> -       } while (need_resched());
> +       add_preempt_count(PREEMPT_ACTIVE);
> +       schedule();
> +       sub_preempt_count(PREEMPT_ACTIVE);
>  }
>  

If you drop the loop, then you should also remove the comment that
explains why it was put there.

	Arnd <><
