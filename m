Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZKCU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZKCU3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZKCU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:29:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:52566 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZKCU3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k0sLHRC6G+zrTw1z9fAm2+c7lgtY9yGVgzlsywShbNxKYXv3z2x16sCGs7a8F3WHRm
         35+EGsCJbXl72L6Sy1alvXx8NjH+bStptu8NPlrgE5YRNGFDhAkY4/TVO7LMpukXVf+h
         9g/oNxejgG3HWbTgWd6cG0bqxlu1nWF8RAslc=
Date: Tue, 3 Nov 2009 21:29:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091103202923.GB4962@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <4AF08B7C.8040903@web.de> <20091103201503.GA4962@nowhere> <4AF090EC.5010105@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF090EC.5010105@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 09:22:04PM +0100, Jan Kiszka wrote:
> > Thinking about it, this check should cover every cases:
> > 
> > if (vcpu->arch.switch_db_regs || __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK)
> > 
> > If we have __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK, it means there is an
> > active breakpoint and then we should restore the current state.
> > 
> 
> And what about (__get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK) only? Would
> you be able to live with unsync'ed hardware and software states?
> 
> Jan
> 


But if the guest has breakpoints activated, the host will inherit
them, which is really not something we want, assuming vcpu->arch.switch_db_regs
already protects us about that.

