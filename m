Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZBWVMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZBWVMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZBWVMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:12:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:41315 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZBWVMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:12:13 -0500
From: Thomas Renninger <trenn@suse.de>
To: alan-jenkins@tuffmail.co.uk, Kay Sievers <kasievers@suse.de>
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Date: Mon, 23 Feb 2009 22:12:23 +0100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
References: <20090218182822.GA19902@srcf.ucam.org> <20090218190943.GF26802@elte.hu> <9b2b86520902190354m259f85d0n97795da7b1b8afdd@mail.gmail.com>
In-Reply-To: <9b2b86520902190354m259f85d0n97795da7b1b8afdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232212.23925.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 12:54:06 pm Alan Jenkins wrote:
> On 2/18/09, Ingo Molnar <mingo@elte.hu> wrote:
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >> On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:
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
> The latest development version of module-init-tools (in the git tree)
> is designed to preserve the kernel link order when resolving builtin
> aliases.  If you have two modules which provide the alias "pci:123",
> they will be loaded in the same order as if they were builtin drivers.
>
> It should work if all the cpufreq drivers provide an alias
> "cpufreq-driver" and userspace just does "modprobe cpufreq-driver".
> You just need to be sure none of the cpufreq drivers provide *other*
> aliases which cause them to be loaded earlier, by udev or some other
> bootscript.
I wonder whether a "cpu:vendor:fam:model:flags:..." alias makes sense.
This would solve autoloading of most cpufreq drivers, but it never looked
important enough.
Other drivers that could make use of this:
  - k8temp/k10temp (Don't know about this one, but AFAIK there exists an
    MSR to read out temperature on latest AMD for which a hwmon driver
    is/should be written)?
  - Microcode update?
  - more?

     Thomas
