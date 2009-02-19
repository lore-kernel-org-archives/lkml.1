Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZBSMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZBSMEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZBSMEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:04:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49117 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZBSMEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:04:09 -0500
Date: Thu, 19 Feb 2009 13:03:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: alan-jenkins@tuffmail.co.uk
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, davej@codemonkey.org.uk,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090219120352.GA1703@elte.hu>
References: <20090218182822.GA19902@srcf.ucam.org> <20090218183137.GD26802@elte.hu> <20090218183641.GA20203@srcf.ucam.org> <20090218190943.GF26802@elte.hu> <9b2b86520902190354m259f85d0n97795da7b1b8afdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520902190354m259f85d0n97795da7b1b8afdd@mail.gmail.com>
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

* Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:

> On 2/18/09, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> >> On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:
> >>
> >> > Nice fix! Where does this information come from? Distro module
> >> > ordering magic? It's rather non-trivial.
> >>
> >> Pretty much. p4-clockmod is never the preferred option because
> >> it does no voltage scaling. speedstep-centrino is now almost
> >> entirely functionally replaced with acpi-cpufreq. The
> >> powernow-k8 issue was a personal communication from davej.
> >
> > I'm wondering whether that priority order should/could be
> > expressed in the module space too - so that distros wouldnt have
> > to replicate this. This is really a piece of information the
> > kernel is best at maintaining.
> 
> The latest development version of module-init-tools (in the 
> git tree) is designed to preserve the kernel link order when 
> resolving builtin aliases.  If you have two modules which 
> provide the alias "pci:123", they will be loaded in the same 
> order as if they were builtin drivers.

very nifty ...

> It should work if all the cpufreq drivers provide an alias 
> "cpufreq-driver" and userspace just does "modprobe 
> cpufreq-driver". You just need to be sure none of the cpufreq 
> drivers provide *other* aliases which cause them to be loaded 
> earlier, by udev or some other bootscript.

yeah. Nice.

	Ingo
