Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbXFFKbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbXFFKbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbXFFKbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:31:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:28408 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXFFKbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cpyhR1cI1Yxge4FThg4pA0VwzGOaZUO5ltFxlThKLA2UcOOC73+JQ6RVK9ICaT0Kc5RusrcANDrcDNRVIhL9mhZEXlkV8DtIRdhSEDVpSyoJL2NP+vSKCLF+RW0bP03G1nkTeVxEDV4jdINbAep8UCXj/hKZ8O3GfHyIUKSDhl0=
Message-ID: <9a8748490706060331w56438ef8j71d9026f324901f8@mail.gmail.com>
Date: Wed, 6 Jun 2007 12:31:32 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "john stultz" <johnstul@us.ibm.com>
Subject: Re: [PATCH -rt] Fix TASKLET_STATE_SCHED WARN_ON()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1181096244.6018.20.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181096244.6018.20.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, john stultz <johnstul@us.ibm.com> wrote:
> --- 2.6-rt.orig/kernel/softirq.c        2007-06-05 18:30:54.000000000 -0700
> +++ 2.6-rt/kernel/softirq.c     2007-06-05 18:36:44.000000000 -0700
> @@ -544,10 +544,17 @@ static void inline
>  __tasklet_common_schedule(struct tasklet_struct *t, struct tasklet_head *head, unsigned int nr)
>  {
>         if (tasklet_trylock(t)) {
> -               WARN_ON(t->next != NULL);
> -               t->next = head->list;
> -               head->list = t;
> -               raise_softirq_irqoff(nr);
> +               /* We may have been preempted before tasklet_trylock
> +                * and __tasklet_action may have already run.
> +                * So double check the sched bit while the takslet

s/takslet/tasklet/

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
