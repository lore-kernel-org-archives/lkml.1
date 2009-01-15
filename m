Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbZAONF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbZAONF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZAONFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:05:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbZAONFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:05:07 -0500
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Brian Rogers <brian@xyzw.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090115125451.GB21839@elte.hu>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org> <1232011723.26761.36.camel@marge.simson.net>
	 <1232014456.8870.26.camel@laptop>
	 <1232015423.13856.5.camel@marge.simson.net>
	 <1232019428.5720.8.camel@marge.simson.net>
	 <1232019686.8870.45.camel@laptop>  <20090115125451.GB21839@elte.hu>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 14:05:01 +0100
Message-Id: <1232024701.8870.47.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 13:54 +0100, Ingo Molnar wrote:
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -283,10 +283,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
>                                                    struct sched_entity,
>                                                    run_node);
>  
> -               if (vruntime == cfs_rq->min_vruntime)
> -                       vruntime = se->vruntime;
> -               else
> -                       vruntime = min_vruntime(vruntime, se->vruntime);
> +               vruntime = min_vruntime(vruntime, se->vruntime);
>         }
>  
>         cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);

That's wrong

