Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZCSS0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZCSS0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760101AbZCSSZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:25:38 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:38324 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1760054AbZCSSZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:25:37 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Thu, 19 Mar 2009 18:23:27 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090319182327.GA3823@hades.domain.com>
References: <20090318225137.GA3766@hades.domain.com> <20090318225428.GA3769@hades.domain.com> <20090319074949.GB17144@elte.hu> <49C232D4.7050004@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C232D4.7050004@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 07:56:04AM -0400, Gregory Haskins wrote:
> Ingo Molnar wrote:
> > * Luis Henriques <henrix@sapo.pt> wrote:
> >
> >   
> >>
> >> Btw: I tried Greg schedtop with this patch and the app behaviour is as expected:
> >>
> >>   $ ./schedtop 
> >>   Exception: unsupported version
> >>     
> >
> > Mind updating the app too and post it here please? It's the only app 
> > that relies on this file AFAIK.
> >   
> 
> I can take care of the update if Luis can just confirm that this patch
> works as expected against his new ABI?

Thanks, Greg.  I just tested your patch to schedtop and I can confirm that it
works just fine in both versions (for v14 and v15).

With respect to the changes to the sched_debug ABI, from what I understood no
one is using it at the moment, right?

> --
> commit 336a22f597769bb5759d561773d05ce666019677
> Author: Gregory Haskins <ghaskins@novell.com>
> Date:   Thu Mar 19 07:54:10 2009 -0400
> 
>     Update to proposed v15 ABI
>    
>     Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> 
> diff --git a/schedtop.cc b/schedtop.cc
> index 4d4c510..f3c9468 100644
> --- a/schedtop.cc
> +++ b/schedtop.cc
> @@ -114,7 +114,7 @@ public:
>                             throw std::runtime_error("error parsing
> version");
>                        
>                         lis >> m_version;
> -                       if (m_version != 14)
> +                       if ((m_version < 14) || (m_version > 15))
>                             throw std::runtime_error("unsupported version");
>                        
>                         state = state_timestamp;
> @@ -219,9 +219,11 @@ private:
>             std::string basename("/" + FormIndex("cpu", m_cpu) + "/rq/");
>             Importer importer(m_smap, is, basename);
>  
> -           importer += "yld_both_empty";
> -           importer += "yld_act_empty";
> -           importer += "yld_exp_empty";
> +           if (m_version < 15){
> +             importer += "yld_both_empty";
> +             importer += "yld_act_empty";
> +             importer += "yld_exp_empty";
> +           }
>             importer += "yld_count";
>             importer += "sched_switch";
>             importer += "sched_count";
> 
> 
> 
> ----------------
> 
> If this patch works, you have my "Acked-by" for Luis' kernel-side patch.

Great! :-)

Regards,
-- 
Luis Henriques
