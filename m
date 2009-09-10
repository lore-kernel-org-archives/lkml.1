Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZIJSqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZIJSqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZIJSqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:46:25 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64184 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZIJSqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mFmiuanYtwngQEY3evli5DPgU7N0ON+/YpoMDnB0Ur9UsUWO6PYZT3i7QRjo6NQMJf
         flI29/vunL9csPioa3HuWhlm5519q6nhAK/SVY4kXh5tpVwMUymA5lOr0NIcgWFwRBMZ
         Vhhd7iPrSy5XkJ3sVv3T7VMKwiTX6bEBHzblc=
Date: Thu, 10 Sep 2009 20:46:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/5] perf_counter: Add open/close pmu callbacks
Message-ID: <20090910184621.GC6421@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-2-git-send-email-fweisbec@gmail.com> <19112.57690.867979.462172@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19112.57690.867979.462172@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 09:22:02PM +1000, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > Add the open() and close() callback to the pmu structure.
> > Open is called when a counter is initialized just after it's allocation
> > and close is called when the counter is about to be released.
> > 
> > These callbacks are useful for example when a pmu has to deal with
> > several registers and needs to maintain an internal list of counters
> > using them. Given such list, the pmu is able to check if the the number
> > of physical registers are still sufficient for the new created counter
> > and then accept or refuse this counter.
> 
> We already do that sort of thing on powerpc for hardware counters.
> 
> It looks to me that you can easily do that stuff in the appropriate
> xxx_perf_counter_init function, since pmu->open() is only called
> immediately on return from one the various xxx_perf_counter_init
> functions, and xxx_perf_counter_init is what says what pmu struct to
> use.
> 
> As for ->close(), that's what counter->destroy is there for.  On
> powerpc, hw_perf_counter_init sets counter->destroy to an appropriate
> destructor function, as does tp_perf_counter_init.  So if you need a
> destructor for breakpoint counters, just make bp_perf_counter_init set
> counter->destroy appropriately.
> 
> Paul.


Right. pmu->open/close is basically a mirror of *_perf_counter_init()
and counter->destroy() but in the pmu layer.

As you prefer I can indeed remove that, the end-result looks a bit
confusing to me too.

