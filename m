Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYKQLam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYKQLam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 06:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYKQLad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 06:30:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYKQLac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:30:32 -0500
Date: Mon, 17 Nov 2008 12:30:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/branch-tracer: Fix a trace recursion on
	branch tracer
Message-ID: <20081117113023.GO28786@elte.hu>
References: <491FA8C8.1040905@gmail.com> <20081116062213.GA32215@elte.hu> <c62985530811152232q2794ce1o6732c241821c6eca@mail.gmail.com> <20081116064948.GD32215@elte.hu> <c62985530811160601j1f1fb09cy7a1ad63b373b85b3@mail.gmail.com> <20081116151019.5ee745f6@tpl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081116151019.5ee745f6@tpl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jonathan Corbet <corbet@lwn.net> wrote:

> On Sun, 16 Nov 2008 15:01:24 +0100
> "Frédéric Weisbecker" <fweisbec@gmail.com> wrote:
> 
> > Ok. Yeah I had some trouble with this "impact" tag, finding it hard to
> > not overlap its message with this of the patch's subject but I better
> > understand now...
> > Perhaps this tag should be explained in
> > Documentation/development-process/5.Posting and SubmittingPatches...
> > (cc-ed Jonathan for the development-process documents)....

this is really only an experimental tag at this point, and not 
mandatory in any way.

> I'll happily do so.  I will confess, though, that I don't really 
> understand how that tag differs from the information which simply 
> belongs in the patch title and changelog.

The impact line (invented by hpa half a year ago and used by the x86 
maintainers for the past couple of months) tries to give a one-line 
"impact of change" risk summary.

Here's a small description about it:

   http://lkml.org/lkml/2008/10/28/67

the impact line is a secondary subject line, it quantifies practical 
impact of changes/bugfixes.

The subject line is often controlled by other principles (subsystem 
tags, scope and subject of change, etc.), and the actual changelog is 
often very verbose and talks about the change, not just the problem it 
solves.

The impact-line also documents the _intended_ impact of a change - 
making it easier to see it later whether a change was contemplated to 
have side-effects originally. If a change says "Impact: cleanup" and 
it turns out to break some systems later on, the discrepancy is very 
clear and well documented. We had cases already where it helped.

It also helps when maintaining changes: it makes it clear whether a 
patch should be backported to -stable, etc. Filtering through 
thousands of changes in search for fixes that matter can be quite hard 
- the impact line helps speed up that workflow too.

The definition and usage if it is still a bit in flux, so i'm not sure 
we want to codify it in Documentation/SubmittingPatches. But if you 
could come up with a description it would at minimum be a nice URL to 
point contributors to :-)

	Ingo
