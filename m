Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYJXLS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYJXLS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYJXLSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:18:47 -0400
Received: from ozlabs.org ([203.10.76.45]:60857 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYJXLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:18:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Date: Fri, 24 Oct 2008 22:18:50 +1100
User-Agent: KMail/1.9.10
Cc: Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081024072147.GA5000@in.ibm.com> <20081024102957.GC4583@redhat.com>
In-Reply-To: <20081024102957.GC4583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242218.50370.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 21:29:57 Oleg Nesterov wrote:
> On 10/24, Gautham R Shenoy wrote:
> > On Fri, Oct 24, 2008 at 02:04:35PM +1100, Rusty Russell wrote:
> > > I think we should BUG_ON(per_cpu(cpu_state, cpuid) != CPU_DEAD) to
> > > ensure we never use work_on_cpu in the hotplug cpu path.  Then we use
> > > smp_call_function() for that hard intel_cacheinfo case.  Finally, we
> > > fix the cpu hotplug path to use schedule_work_on() itself rather than
> > > playing games with cpumask.
> > >
> > > If you agree, I'll spin the patches...
> >
> > How about the following?
> >
> > We go with this method, but instead of piggybacking on
> > the generic kevents workqueue, we create our own on_each_cpu_wq, for this
> > purpose.
>
> Gautham, Rusty, I am a bit lost on this discussion...
>
> Why should we care about this deadlock? Just do not use work_on_cpu() from
> the hotplug cpu path, that is all.

No, I agree with you (Oleg).  Gautham's proposal would work, but at the cost 
of yet another thread per CPU :(

Since we know how to handle the one problematic case Oleg spotted, *and* we 
know how to BUG_ON to make sure noone introduces new ones, I think this is 
clearest.

Thanks,
Rusty.
