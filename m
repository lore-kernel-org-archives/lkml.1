Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZFFO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZFFO4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZFFO43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:56:29 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38819 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZFFO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iyvyIWqMnIccxPzRtvGjvkhU9OnB8zAibi8ayah05S329G6Yfm2dGq6eZzoRjdhcCl
         b0+dVwEi2Cyt7xhVAeN6WgjFU8ppJWpTUGsozmw35zIOP9Bn4ZYVMIK3X42Xc+CFakfA
         /9fGI7oSTGkIUl33Ty0KBiZ9SUemLeXQMmauc=
Date: Sat, 6 Jun 2009 16:56:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing/branch-tracer: PROFILE_BRANCHES_PER_CPU must
	depend on SMP
Message-ID: <20090606145626.GB6008@nowhere>
References: <20090606073128.GA7321@elte.hu> <1244299043-7613-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0906061041150.9522@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906061041150.9522@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 10:42:29AM -0400, Steven Rostedt wrote:
> 
> On Sat, 6 Jun 2009, Frederic Weisbecker wrote:
> > 
> > [ Impact: fix a build failure with the branch tracer ]
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index 309a264..0efbcc5 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -285,7 +285,7 @@ endchoice
> >  
> >  config PROFILE_BRANCHES_PER_CPU
> >  	bool "Profile branches on a per cpu basis"
> > -	depends on PROFILE_ALL_BRANCHES
> > +	depends on PROFILE_ALL_BRANCHES && SMP
> 
> You just wasted two minutes of my time!
> 
> I was just about to send out the same patch, but you beat me to it. ;-)
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>



We really need a mutex... ;-)

Frederic.


> 
> -- Steve
> 
> 
> >  	help
> >  	  When profiling all branches, the system can take a big cache line
> >  	  bouncing hit. On boxes with lots of CPUs, this can slow the system
> > -- 
> > 1.6.2.3
> > 
> > 

