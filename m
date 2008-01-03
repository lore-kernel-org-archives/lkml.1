Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYACNG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYACNG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYACNG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:06:29 -0500
Received: from mx1.suse.de ([195.135.220.2]:56746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYACNG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:06:28 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [11/20] x86: Use the correct cpuid method to detect MWAIT support for C states
Date: Thu, 3 Jan 2008 13:53:59 +0100
User-Agent: KMail/1.9.6
Cc: andreas.herrmann3@amd.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20080103149.088038000@suse.de> <20080103005006.BE79A14D40@wotan.suse.de> <20080103104526.GC29194@elte.hu>
In-Reply-To: <20080103104526.GC29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031353.59426.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 11:45:26 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > +static int mwait_usable(const struct cpuinfo_x86 *c)
> > +{
> > +	if (force_mwait)
> > +		return 1;
> > +	/* Any C1 states supported? */
> > +	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
> > +}
> > +
> >  void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
> >  {
> > -	if (cpu_has(c, X86_FEATURE_MWAIT)) {
> > +	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
> >  		printk("monitor/mwait feature present.\n");
> 
> hm, why not clear FEATURE_MWAIT if it's "not usable"? That's the 
> standard approach we do for CPU features that do not work.

Well it works, just in a unexpected way not useful to the kernel.

At least on AMD there is a bit to enable it for ring 3 too, so 
in theory someone could use it anyways.

-Andi

