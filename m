Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0CERRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:17:39 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:58811 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0CERRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gQZuDFLPE574NOirFVPxgkaR+peONqWG5Fnfngl3jaG+VhKVMtmR0Tdqvrn0DedJ2l
         UNFir1ceumz6mwhU/9vy2I+kygH/nsGsV2EZnK0erN+N927GWue/vtBuvxjTrAdPlAuf
         3D5AMZoDorHS86Yf1eYzXPmejNxFVhU31pPJ8=
Date: Fri, 5 Mar 2010 18:17:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H . Peter Anvin" <hpa@zytor.com>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Archs <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf: Introduce new perf_save_regs() for hot regs
	snapshot
Message-ID: <20100305171734.GD5244@nowhere>
References: <1267605529.25158.75.camel@laptop> <1267758486-30499-2-git-send-regression-fweisbec@gmail.com> <4B911E57.60004@redhat.com> <20100305163838.GA5244@nowhere> <4B913A83.4040805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B913A83.4040805@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 12:08:19PM -0500, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > On Fri, Mar 05, 2010 at 10:08:07AM -0500, Masami Hiramatsu wrote:
> >>> +void perf_arch_save_regs(struct pt_regs *regs, unsigned long ip, int skip)
> >>
> >> Hmm, why would you call it 'save_regs' ?
> >> It seems that this function is just for fixing registers 
> >> instead of saving it into somewhere...
> >>
> >> Thank you,
> > 
> > 
> > Hmm, save_regs() describes what it does: you pass
> > a pt_regs and it saves registers inside. But it
> > has also a kind of fixup thing as it also rewinds.
> 
> Ah, I see. so this saves current register values
> into pt_regs. :)
> 
> > 
> > I'm not sure using a fixup thing for the naming
> > is correct as we are not starting with initial
> > regs passed to the function (just a raw buffer).
> > 
> > What about perf_save_caller_regs() ?
> > 
> 
> Hmm, I think, it might be better perf_get_caller_regs()
> or something like that (fetch ?). 


perf_fetch_caller_regs() looks fine. I'll update my
patch accordingly, thanks.

