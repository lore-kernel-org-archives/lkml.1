Return-Path: <linux-kernel-owner+w=401wt.eu-S932477AbZJGITP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbZJGITP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbZJGITO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:19:14 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:52252 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbZJGITL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rg8fQugA/My0hgTV2ik74aI2/JBH9FYB9z4K+UcGpTsnN0x8ePLqFTTAjCeA4iIyPG
         l3H8uXcgRzQKyj/cM5x78DijY+sdH/3khwqvANQF9sFCuETh+QA5Tl7b80bKw+MAFqlM
         xW9xVcquziyLUjXs08P/OessJ5cxhhyRXvFzo=
Date: Wed, 7 Oct 2009 10:18:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] perf tools: Merge trace.info content into
	perf.data
Message-ID: <20091007081832.GB5043@nowhere>
References: <20091006213643.GA5343@nowhere> <20091007062204.GE21673@elte.hu> <20091007064355.GA3283@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007064355.GA3283@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:43:55AM +0200, Ingo Molnar wrote:
> Meanwhile i've applied your two patches - they are clear steps forward. 
> We'll need the -stable fix so that the new perf.data can be read. (and 
> even that only affects -R afaics - so normal perf record / perf report 
> is compatible.)



That affects every new perf.data
We have a new trace_info offset/size pair even if we haven't
any trace.info, these will just be zero in that case.
This new pair has grown the header, making it uncompatible.

But the stable patch should solve this.

 
> Btw., we also need a patch for new perf to read older perf.data files 
> [non-trace.info ones], as those are not working either:
> 
>  $ perf report
>    Fatal: incompatible file format
> 
> ( We dont want to push it - i.e. i dont think we need to support old
>   perf.data + trace.info combos. )
> 
> 	Ingo

Ok.

