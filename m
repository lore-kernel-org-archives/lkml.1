Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYADJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYADJmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYADJmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:42:23 -0500
Received: from www.tglx.de ([62.245.132.106]:33384 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYADJmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:42:22 -0500
Date: Fri, 4 Jan 2008 10:42:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less
 frequently
In-Reply-To: <20080103154226.67D6414DDB@wotan.suse.de>
Message-ID: <alpine.LFD.0.99999.0801041032430.4042@localhost.localdomain>
References: <20080103442.621670000@suse.de> <20080103154226.67D6414DDB@wotan.suse.de>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008, Andi Kleen wrote:
> This makes a significant difference in boot up performance on AMD SimNow!
> Also I expect it to be a little faster on native systems too because a smp 
> switch does a lot of text_poke()s which each synchronize the pipeline.

Please run your patches through checkpatch.pl.

ERROR: use tabs not spaces
#48: FILE: arch/x86/kernel/alternative.c:360:
 
> +
> +		/* Only switch to UP mode if we don't immediately boot others */
> +		if (num_possible_cpus() == 1 || max_cpus == 0)

Shouldn't this be max_cpus <= 1 ?

> +extern unsigned int max_cpus;

I'm a bit wary about making max_cpus global. max_cpus is used all over
the place as a local variable name. Can we please rename it to
setup_max_cpus or something like that?

Thanks,

	tglx
