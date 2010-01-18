Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674Ab0ARNcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab0ARNcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433Ab0ARNck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:32:40 -0500
Received: from relay1.sgi.com ([192.48.179.29]:47444 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0ARNck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:32:40 -0500
Date: Mon, 18 Jan 2010 07:35:04 -0600
From: Cliff Wickman <cpw@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roel Kluin <roel.kluin@gmail.com>, Robin Holt <holt@sgi.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: bau_msg_head points to a_queue_first in
	uv_table_bases_finish()
Message-ID: <20100118133504.GA11428@sgi.com>
References: <4B507093.6050002@gmail.com> <20100117071227.GC19512@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117071227.GC19512@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Jan 17, 2010 at 08:12:27AM +0100, Ingo Molnar wrote:
> 
> * Roel Kluin <roel.kluin@gmail.com> wrote:
> 
> > bau_msg_head should point to bau_msg_head
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > Is this correct?
> > 
> > diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
> > index 364d015..3d66331 100644
> > --- a/arch/x86/kernel/tlb_uv.c
> > +++ b/arch/x86/kernel/tlb_uv.c
> > @@ -691,7 +691,7 @@ uv_table_bases_finish(int blade,
> >  			continue;
> >  
> >  		bcp = (struct bau_control *)&per_cpu(bau_control, cpu);
> > -		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
> > +		bcp->bau_msg_head	= bau_tablesp->bau_msg_head;
> >  		bcp->va_queue_first	= bau_tablesp->va_queue_first;
> >  		bcp->va_queue_last	= bau_tablesp->va_queue_last;
> >  		bcp->msg_statuses	= bau_tablesp->msg_statuses;
> 
> Seems like you either caught a real bug - or that there's a somewhat quirky 
> initialization sequence here which should be commented upon in the source.
> 
> Cliff, Robin, what's your take on Roel's patch?
> 
> Thanks,
> 
> 	Ingo

The bau_tablesp->bau_msg_head doesn't seem to be initialized, so do not
change the code this way.

bcp->bau_msg_head is correctly initialized to the head of the queue as
it stands.

However I do agree that it is confusing, as there are redundant control
structures, and needs improvement.  I intend to submit a new version
of tlb_uv.c soon.

-Cliff

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
