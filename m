Return-Path: <linux-kernel-owner+w=401wt.eu-S935048AbZLPQiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935048AbZLPQiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935002AbZLPQiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:38:15 -0500
Received: from isilmar.linta.de ([213.133.102.198]:56852 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757049AbZLPQiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:38:14 -0500
Date: Wed, 16 Dec 2009 17:38:11 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Cc: "davej@redhat.com" <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "mjg@redhat.com" <mjg@redhat.com>, "trenn@suse.de" <trenn@suse.de>,
       "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH] cpufreq: Processor Clocking Control interface driver
Message-ID: <20091216163811.GA18921@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
	"davej@redhat.com" <davej@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"mjg@redhat.com" <mjg@redhat.com>, "trenn@suse.de" <trenn@suse.de>,
	"lenb@kernel.org" <lenb@kernel.org>
References: <20091128034424.6796.75673.sendpatchset@localhost.localdomain> <20091211231233.GA4291@isilmar.linta.de> <66D9D2F0CDB5C9428E6166B01EC85EE161DEEE3CB7@GVW0676EXC.americas.hpqcorp.net> <20091215183331.GA5560@comet.dominikbrodowski.net> <66D9D2F0CDB5C9428E6166B01EC85EE161DEEE4166@GVW0676EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66D9D2F0CDB5C9428E6166B01EC85EE161DEEE4166@GVW0676EXC.americas.hpqcorp.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Dec 16, 2009 at 03:31:48PM +0000, Chumbalkar, Nagananda wrote:
> >> >> +	if (target_freq <= 
> >> >(ioread32(&pcch_hdr->minimum_frequency) * 1000)) {
> >> >> +		target_freq = 
> >> >ioread32(&pcch_hdr->minimum_frequency) * 1000;
> >> >> +		dprintk("target: target_freq for cpu %d was 
> >> >below limit, "
> >> >> +			"converted it to %d\n", cpu, target_freq);
> >> >> +	}
> >> >
> >> >why not do this in the _verify() step? Does 
> >pcch_hdr->minimum_frequency
> >> >even change "on the fly"?
> >> 
> >> pcch_hdr->minimum_frequency does not change "on the fly". 
> >Also, there is no
> >> need for those IO accesses:
> >
> >target_freq cannot be below policy->min or above policy->max. 
> >If it were,
> >the whole cpufreq subsystem is broken. So there's no need for 
> >these checks,
> >AFAICS.
> >
> 
> I think the "ondemand" governor can ask for a target frequency that is
> below policy->min.
> 
> Let's say that at a given snapshot, the frequency of a CPU is policy->cur.
> At the next sampling, if the "load" on the CPU drops to a level that 
> satisifies the equation below, then freq_next requested by "ondemand" 
> will be below policy->min:
> 
> 	load < (threshold - differential) * policy->min / policy->cur
> 
> A patch such as below may be needed to sanitize the target frequency 
> requested by "ondemand". The "conservative" governor already has this check: 

If freq_next < policy->min is indeed possible in ondemand, that's a real bug
in ondemand.

Best,
	Dominik
