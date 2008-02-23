Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbYBWCoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbYBWCoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYBWCoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:44:21 -0500
Received: from waste.org ([66.93.16.53]:52057 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbYBWCoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:44:20 -0500
Subject: Re: [RFC] [PATCH] x86: Use ELF section to list CPU vendor specific
	code (Linux Tiny)
From: Matt Mackall <mpm@selenic.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080215120023.252647bd@crazy>
References: <200802082347.25364.michael-lists@free-electrons.com>
	 <20080208231130.GA10511@elte.hu>
	 <200802112342.23493.michael-lists@free-electrons.com>
	 <1202770566.12383.59.camel@cinder.waste.org> <47B0D3B7.6070308@zytor.com>
	 <1202772532.12383.67.camel@cinder.waste.org> <47B0EE46.6050208@zytor.com>
	 <20080215120023.252647bd@crazy>
Content-Type: text/plain; charset=utf-8
Date: Sat, 23 Feb 2008 10:43:37 +0800
Message-Id: <1203734617.14838.169.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 12:00 +0100, Thomas Petazzoni wrote:
> Hi,
> 
> Le Mon, 11 Feb 2008 16:54:30 -0800,
> "H. Peter Anvin" <hpa@zytor.com> a écrit :
> 
> > b) would be my first choice, and yes, it would be a good thing to
> > have a generalized mechanism for this.  For the registrant, it's
> > pretty easy: just add a macro that adds a pointer to a named
> > section.  We then need a way to get the base address and length of
> > each such section in order to be able to execute each function in
> > sequence.
> 
> You'll find below a tentative patch that implements this. Tuple
> (vendor, pointer to cpu_dev structure) are stored in a
> x86cpuvendor.init section of the kernel, which is then read by the
> generic CPU code in arch/x86/kernel/cpu/common.c to fill the cpu_devs[]
> function.

This is not quite what Peter and I were thinking of, I think. It's not
at all generic. How about a section that simply contains a set of
function pointers, a macro to add things to that section, and a function
that calls all the pointers in that section. Eg:

CALLBACK_SECTION(init_cpu_amd, "cpuvendor.init");
invoke_callback_section("cpuvendor.init");

..which would give us a generic facility we could use in various places.

-- 
Mathematics is the supreme nostalgia of our time.

