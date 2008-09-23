Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbYIWKBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbYIWKBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 06:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYIWKA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 06:00:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41715 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYIWKA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:00:57 -0400
Date: Tue, 23 Sep 2008 12:00:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Patch -tip 0/4] Creation of the initcall tracer
Message-ID: <20080923100034.GA23118@elte.hu>
References: <48D8C516.4090706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48D8C516.4090706@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,WHOIS_NETSOLPR autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 WHOIS_NETSOLPR         URL registered as a NetSol Private Registration
	[URIs: youtube.com]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> This patchset is about the initcall tracer requested by Ingo Molnar. 
> It is supposed to replace the printk involved during fastboot if the 
> initcall_debug parameter has been selected.

that was fast! :)

i've created a new -tip topic for your new tracer: tip/tracing/fastboot. 
That topic is based on the tip/tracing/ftrace + tip/fastboot trees.

Note that i've done a couple of small changes to your patches:

 - i've done the following renames:

      :1,$s/INITCALL_TRACER/BOOT_TRACER/g
      :1,$s/trace_initcall/trace_boot/g
      :1,$s/initcall_trace/boot_trace/g

   the reasoning: we eventually want to extend this new tracer to all 
   things "bootup delay", not just initcalls - hence calling it an
   'initcall tracer' would be too limiting.

   The goal is to help the Arjan's fastboot project to achieve 5 seconds 
   to-GUI bootup times like this:

      http://www.youtube.com/watch?v=s7NxCM8ryF8

   [ Even if you know what a 5 seconds bootup is, you've got to check 
     this "From Naught to Sixty in 5 seconds" video ;-) ]

 - there were a few overlong lines in the commit logs and in the Kconfig 
   desciption - i fixed them up. You should check your email client and 
   your editor for line length settings - currently you seem to have no
   line breaks at all.

 - I also corrected a few capitalization things in commit subject lines 
   and corrected a few minor coding style errors - you can avoid these 
   by running scripts/checkpatch.pl over your patches. Nothing overly
   serious - but you should diff against tip/master to see what the 
   changes are.

> Currently this tracer is a test. Its output is not yet adapted for 
> scripts/bootgraph.pl which uses the old initcalls printk to produce a 
> graph. But since this tracer will output sched_switch and stack_trace, 
> we should first talk about the future output format of this tracer in 
> sync with bootgraph.pl
> 
> It currently not uses the sched_switch and stack_trace tracers since 
> related functions of insertion into the ring buffer perhaps need first 
> to be moved on their own tracer file. But it have to be discussed.
> 
> Note that you need the initcall_debug to enable this tracer. When 
> printk from initcall_debug will disappear, we could surely enable this 
> tracer by default without this parameter.
> 
> Old printk have been kept for backward compatibility.

yes, it's necessary to keep that backwards compatibility.

i've integrated tip/tracing/fastboot into tip/master and have started 
testing it. It passed the basic tests already so i've just pushed out 
the new tip/master. Please double-check that i have not messed up the 
rename or the integration somewhere.

all in one, nice stuff!

	Ingo
