Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYISRQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYISRQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYISRP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:15:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:18744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYISRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K6L8lQMG+pPmFTaduBAVAhEpglQltRcS1gvmebvtud/4BxCGBQpMRnRo97agg3K3Sq
         EbH7kzugkz7h3LcxyKyb02Qtmio9hhq0UqFWIDw/h48aMdCPxuxZlmbWFfnRIKduG0nJ
         2s/bNXzXpxy7MtslTlAESoweRvLK9/NQnZUQk=
Date: Fri, 19 Sep 2008 19:15:21 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Print cpuid along with the timestamp with
	CONFIG_PRINTK_TIME
Message-ID: <20080919171516.GB5540@joi>
References: <20080918193720.GA21915@localdomain> <20080918125123.1a76978f.akpm@linux-foundation.org> <20080919003509.GB21915@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919003509.GB21915@localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 05:35:09PM -0700, Ravikiran G Thirumalai wrote:
> On Thu, Sep 18, 2008 at 12:51:23PM -0700, Andrew Morton wrote:
> >On Thu, 18 Sep 2008 12:37:20 -0700
> >Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> >> 
> >> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> >> 
> >> Index: linux-git/kernel/printk.c
> >> ===================================================================
> >> --- linux-git.orig/kernel/printk.c	2008-09-16 15:37:48.000000000 -0700
> >> +++ linux-git/kernel/printk.c	2008-09-18 12:27:10.489662938 -0700
> >> @@ -739,9 +739,10 @@ asmlinkage int vprintk(const char *fmt, 
> >>  
> >>  				t = cpu_clock(printk_cpu);
> >>  				nanosec_rem = do_div(t, 1000000000);
> >> -				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
> >> +				tlen = sprintf(tbuf, "[%5lu.%06lu:%d] ",
> >>  						(unsigned long) t,
> >> -						nanosec_rem / 1000);
> >> +						nanosec_rem / 1000,
> >> +						printk_cpu);
> >>  
> >>  				for (tp = tbuf; tp < tbuf + tlen; tp++)
> >>  					emit_log_char(*tp);
> >
> >
> >Your patch illogically ties the cpu-id-printing feature to the
> >printk.time feature.  I guess that's liveable with, but
> >Documentation/kernel-parameters.txt should be updated.
> >
> 
> Didn't realize Documentation/kernel-parameters.txt had reference and even a
> runtime parameter to control this!  I always enabled CONFIG_PRINTK_TIME
> to get timestamps. Here's an updated patch.
> 
> As for the cpuid with the timestamp, the timestamp that is being
> is  the printed the cpu's time stamp.

Do we really need this information on UP kernels?
Why don't you add another option for this feature?

Marcin
