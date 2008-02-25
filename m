Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYBYR7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYBYR7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbYBYR7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:59:12 -0500
Received: from waste.org ([66.93.16.53]:40984 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168AbYBYR7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:59:11 -0500
Subject: Re: [RFC] [PATCH] x86: Use ELF section to list CPU vendor specific
	code (Linux Tiny)
From: Matt Mackall <mpm@selenic.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       michael@free-electrons.com
In-Reply-To: <20080225185358.19fff688@crazy>
References: <200802082347.25364.michael-lists@free-electrons.com>
	 <20080208231130.GA10511@elte.hu>
	 <200802112342.23493.michael-lists@free-electrons.com>
	 <1202770566.12383.59.camel@cinder.waste.org> <47B0D3B7.6070308@zytor.com>
	 <1202772532.12383.67.camel@cinder.waste.org> <47B0EE46.6050208@zytor.com>
	 <20080215120023.252647bd@crazy>
	 <1203734617.14838.169.camel@cinder.waste.org>
	 <20080225092933.6a8dbc36@crazy> <1203958992.7461.46.camel@cinder.waste.org>
	 <20080225185358.19fff688@crazy>
Content-Type: text/plain; charset=utf-8
Date: Mon, 25 Feb 2008 09:58:24 -0800
Message-Id: <1203962304.1878.2.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 18:53 +0100, Thomas Petazzoni wrote:
> Le Mon, 25 Feb 2008 09:03:12 -0800,
> Matt Mackall <mpm@selenic.com> a écrit :
> 
> > > > This is not quite what Peter and I were thinking of, I think.
> > > > It's not at all generic. How about a section that simply contains
> > > > a set of function pointers, a macro to add things to that
> > > > section, and a function that calls all the pointers in that
> > > > section. Eg:
> > > > 
> > > > CALLBACK_SECTION(init_cpu_amd, "cpuvendor.init");
> > > > invoke_callback_section("cpuvendor.init");
> > > > 
> > > > ..which would give us a generic facility we could use in various
> > > > places.
> > > 
> > > I see. Probably doable. How would it work in the LD script file ?
> > > Your mechanism allows to specify any section name, but AFAIK, the
> > > sections must be explicitly listed in the kernel LD script in order
> > > to be included in the final kernel image. Am I missing something ?
> > 
> > I can't see any way to avoid it, but we can leave it to future
> > generations to come up with something more clever.
> 
> After a quick look at the LD documentation, it seems that wildcards are
> supported in the input section names of the linker script. So that the
> CALLBACK_SECTION() macro could add the function pointer to a section
> named:
> 
>    gcm. ## name
> 
> (gcm standing for "generic callback mechanism") and then, in the linker
> script, do:
> 
>    *(gcm.*)
> 
> I'm going to try that.

Sounds great! But I'd rather the base name be "callback" so it'll be
obvious what it is when people dump section names.

-- 
Mathematics is the supreme nostalgia of our time.

