Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZKWJfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZKWJfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZKWJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:35:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbZKWJfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:35:30 -0500
Date: Mon, 23 Nov 2009 10:35:35 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size config options
Message-ID: <20091123093535.GK5602@wotan.suse.de>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com> <20091116041407.GB5818@wotan.suse.de> <4B011677020000780001FD9D@vpn.id2.novell.com> <20091116105657.GE5818@wotan.suse.de> <20091119035640.GA18236@elte.hu> <20091118205240.11d3d660@infradead.org> <20091119081307.GA20534@wotan.suse.de> <20091119075958.2cba15f8@infradead.org> <20091123083459.GB11443@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123083459.GB11443@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 09:34:59AM +0100, Ingo Molnar wrote:
> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Thu, 19 Nov 2009 09:13:07 +0100
> > Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > My other point was just this, but I don't care too much. But it is
> > > worded pretty negatively. The key here is that increasing the value
> > > too large tends to only cost a very small amount of size (and no
> > > increase in cacheline foot print, only RAM). 
> > 
> > 128 has a pretty significant impact on TPC-C benchmarks.....
> > it was the top issue until mainline fixed it to default to 64
> 
> Mind sending a patch that sets the default to 64 on NUMA too?

This is what I mean. It should all be the same value, and that
value should depend on the architectures to support (rather than
NUMA or something like that). With the internode simply being
the exception for the exceptional vSMP architecture.

 
> P4 based NUMA boxes are ... a bad memory to be forgotten.

I still think it would make sense to do this via Kconfig rather
than implicitly saying that we don't care about P4s even if
the user has apparently wanted to support them.


