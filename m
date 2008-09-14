Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYINM0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYINM0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYINM0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:26:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYINM0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:26:38 -0400
Date: Sun, 14 Sep 2008 14:26:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
Message-ID: <20080914122618.GD16097@elte.hu>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org> <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de> <20080914112222.GA3956@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914112222.GA3956@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> On Fri 2008-09-12 23:19:21, Thomas Gleixner wrote:
> > On Fri, 12 Sep 2008, Andi Kleen wrote:
> > > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> > > >
> > > > to see how wrong could be set by BIOS.
> > > 
> > > Just dump it from user space then.  There are plenty of tools
> > > to access ACPI tables.
> > 
> > 1.) what guarantees that we reach user space ?
> 
> We can dump in *any* kernel.
>
> > 2) If it is _valuable_ information which we can gather via kernel
> >    output, then it is much more conveniant than asking the user to type
> >    whatevercryptictoolcommandline and provide the output.
> 
> Ooh, 'lets dump more junk at everyone, typing commands is hard' :-(.

no, the principle is, information like the boot-time CPUID information 
(and even the BIOS environment) can be indicative of _kernel bugs_. It 
is often essential to dump what the booting (and failing) kernel thinks 
is its environment.

Often that environment is corrupted (by the kernel) and that leads to 
problems. This 'environment' can also be affected by things like hard 
boot vs cold boot differences, whether it's in a kexec environment, 
whether it's booted as a virtual guest, etc., etc.

For a long time we had the kernel's x86 bootup pretty much as a mostly 
silent black box and when it broke we tried to figure things out 
afterwards which was difficult and error-prone. Now we've got various 
quite effective debug mechanisms (which includes printouts as well) and 
figuring out x86 problems is visibly easier. We definitely wont go back 
to the 'black box code, can only be debugged by a few experts' method.

So extending on that is a good and obvious idea in general - and i agree 
with Peter that this should be command-line dependent, i.e. not printed 
by default. Only printing it when 'debug' is specified on the command 
line is a good solution.

	Ingo
