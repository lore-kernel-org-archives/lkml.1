Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYADM0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYADM0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYADM0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:26:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:34945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYADM0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:26:39 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less frequently
Date: Fri, 4 Jan 2008 13:17:30 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154226.67D6414DDB@wotan.suse.de> <alpine.LFD.0.99999.0801041032430.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.99999.0801041032430.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041317.30404.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 10:42:17 Thomas Gleixner wrote:
> On Thu, 3 Jan 2008, Andi Kleen wrote:
> > This makes a significant difference in boot up performance on AMD SimNow!
> > Also I expect it to be a little faster on native systems too because a smp 
> > switch does a lot of text_poke()s which each synchronize the pipeline.
> 
> Please run your patches through checkpatch.pl.
> 
> ERROR: use tabs not spaces
> #48: FILE: arch/x86/kernel/alternative.c:360:


I saw a lot of these warnings, but disregarded them as obviously silly. I don't
have plans to redo all the patches for that.
  
> > +
> > +		/* Only switch to UP mode if we don't immediately boot others */
> > +		if (num_possible_cpus() == 1 || max_cpus == 0)
> 
> Shouldn't this be max_cpus <= 1 ?

Don't think so, smp_init() seems to use it one off.
 
> > +extern unsigned int max_cpus;
> 
> I'm a bit wary about making max_cpus global. max_cpus is used all over
> the place as a local variable name. Can we please rename it to
> setup_max_cpus or something like that?

Hmm, I didn't see any warnings from this so surely it's not a big issue?

-Andi
