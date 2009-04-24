Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZDXU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZDXU56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZDXU5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:57:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:51767 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZDXU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=irKdwk1E2vH3zdqyGZ6wEup6uX6eNKyc3E19AfrJ9sJk2LACAFPEF8aGedLxgW9Rwv
         A+Xbb6WmfCnE8av/hymnZZbqKMtnXyHREyH11stxsTx4/XvcRoG9gtxNeQqg6kxYvDvq
         9QqtIrjzoDP3DQOZwMvFXOm7awXTyZL7BsO1E=
Date: Fri, 24 Apr 2009 22:57:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [Patch 11/12] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v3
Message-ID: <20090424205741.GA6009@nowhere>
References: <20090424055710.764502564@prasadkr_t60p.in.ibm.com> <20090424061849.GL23812@in.ibm.com> <20090424072141.GC5993@nowhere> <20090424091347.GA29830@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424091347.GA29830@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 02:43:47PM +0530, K.Prasad wrote:
> On Fri, Apr 24, 2009 at 09:21:42AM +0200, Frederic Weisbecker wrote:
> > On Fri, Apr 24, 2009 at 11:48:50AM +0530, K.Prasad wrote:
> > > This patch adds an ftrace plugin to detect and profile memory access over kernel
> > > variables. It uses HW Breakpoint interfaces to 'watch memory addresses.
> > 
> > 
> > Just a small concern, but it would be nice if you could include the history
> > of this patch in the changelogs.
> > 
> > 
> >
> 
> Hi Frederic,
> 	Thanks for looking into the patch. I will provide the history of
> changes here. The ULONG_MAX definition from linux/kernel.h is now used
> and the permission for the 'ksym_trace_filter' file is now set to 644
> (similar to other ftrace plugin filters).
> 
> Changelog
> ---------
> (since the first post of this patch here: http://lkml.org/lkml/2009/3/4/418)
> 
> - Addition of a startup selftest to test basic sanity of HW Breakpoint
>   infrastructure.
> - Implementation of a ftrace's stats facility over ksym_tracer to
>   provide aggregate 'hit' counter values.
> - Conversion of all locking primitives into spinlocks (ksym_tracer_lock)
>   from previous mutex implementation (since stats collection happens inside
>   the context of the breakpoint exception and we cannot sleep).
> - A few changes in ksym_trace_filter_write() and
>   process_new_ksym_entry() to eliminate passing of unnecessary values.
> - Fixed a few potential memory leak scenarios (missing kfree()
>   operations in return path) along with other minor issues pointed out in LKML.
> - Minor code changes such as unconditional definition of 'struct
>   trace_ksym' - irrespective of CONFIG_KSYM_TRACER.



Thanks! Such history is very useful to understand a patch. They
can explain some logic reasoning of a patch, especially between
versions.


 
> ftrace plugin for kernel symbol tracing using HW Breakpoint interfaces - v3
> 
> This patch adds an ftrace plugin to detect and profile memory access over kernel
> variables. It uses HW Breakpoint interfaces to 'watch memory addresses.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>


It looks good.
Thanks!

