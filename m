Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYBSQaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYBSQaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYBSQ37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:29:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:43160 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYBSQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:29:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=WcMp++YANo9CcIuo4ReiXcgt5RoWFT89dLmJJEuzTpVNUTUzsl7KMVyWnbJGQtBOkW0bdJBs17a65mT3usgtj/UwCSEzQoWjnY2zQP3Ds6mRulyz8N6SRFELno7ZtrLw1pzUwN7kZnp7G2AI0hsFbIavF1VGxbu9yacoaE6pgVM=
Date: Tue, 19 Feb 2008 18:27:18 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Tasklets: Avoid duplicating __tasklet_{,hi_}schedule()
	code
Message-ID: <20080219162718.GA3372@ubuntu>
References: <20080219153720.GA2967@ubuntu> <20080219155252.GA27280@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219155252.GA27280@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 04:52:52PM +0100, Ingo Molnar wrote:
> 
> * Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> 
> > -		local_irq_disable();
> > -		t->next = __get_cpu_var(tasklet_vec).list;
> > -		__get_cpu_var(tasklet_vec).list = t;
> > -		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
> > -		local_irq_enable();
> > +		/* We were not lucky enough to run, reschedule. */
> > +		__tasklet_schedule(t);
> 
> i think there's a subtle difference that you missed: this one does 
> __raise_softirq_irqoff(), while __tasklet_schedule() does a 
> raise_softirq_irqoff(). (note the lack of undescores)
> 
> the reason is to avoid infinitely self-activating tasklets.
> 

Indeed, thanks a lot for the explanation. (maybe it's time to check
for new eyeglasses ;)).

Regards

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

