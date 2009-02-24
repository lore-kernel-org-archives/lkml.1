Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZBXPPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZBXPPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZBXPPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:15:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbZBXPPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:15:46 -0500
Date: Tue, 24 Feb 2009 16:15:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224151512.GA12438@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org> <20090224124042.GA31295@elte.hu> <49A3F5C5.4060107@kernel.org> <20090224141217.GA17287@elte.hu> <49A40624.4000100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A40624.4000100@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> > It's still about this restriction:
> > 
> > +       /*
> > +        * If large page isn't supported, there's no benefit in doing
> > +        * this.  Also, embedding allocation doesn't play well with
> > +        * NUMA.
> > +        */
> > +       if (!cpu_has_pse || pcpu_need_numa())
> > +               return -EINVAL;
> > 
> > This is what makes no sense (why force the static percpu area 
> > into 4K mappings on NUMA).
> 
> No, the first allocator tried is remap allocator which will do 
> the 2MB remapping thing if NUMA.  If not, it gives its way to 
> embedding allocator which only kicks in for pse && !numa.  The 
> 4k thing is just the last resort.  We might as well kill it 
> and make it
> 
>  if (numa)
> 	do remap
>  else
> 	do embed
>  panic if failed
> 
> The 4k thing is the final fallback for cases where pse isn't 
> supported.

ah, ok :-) Then i was confused by that and wanted to see 
something implemented that ... was already there :)

	Ingo
