Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZKSQSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZKSQSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZKSQSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:18:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:36926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZKSQSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:18:02 -0500
Date: Thu, 19 Nov 2009 17:18:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size config options
Message-ID: <20091119161807.GC5602@wotan.suse.de>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com> <20091116041407.GB5818@wotan.suse.de> <4B011677020000780001FD9D@vpn.id2.novell.com> <20091116105657.GE5818@wotan.suse.de> <20091119035640.GA18236@elte.hu> <20091118205240.11d3d660@infradead.org> <20091119081307.GA20534@wotan.suse.de> <20091119075958.2cba15f8@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119075958.2cba15f8@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 07:59:58AM -0800, Arjan van de Ven wrote:
> On Thu, 19 Nov 2009 09:13:07 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> > 
> > My other point was just this, but I don't care too much. But it is
> > worded pretty negatively. The key here is that increasing the value
> > too large tends to only cost a very small amount of size (and no
> > increase in cacheline foot print, only RAM). 
> 
> 128 has a pretty significant impact on TPC-C benchmarks.....
> it was the top issue until mainline fixed it to default to 64

Really? I'm surprised, how much was it?

AFAIKS, in any case that 128 byte alignment is used, cache footprint
should not increased on a 64B line system, over 64 byte alignment.

I do see a silly thing in slab code that does not build a 192 byte
kmalloc slab in the case L1 cache bytes is 128 (it should build the
slab for the possibility that we've booted on a 64 byte system).
That might be increasing memory footprint a bit. But I still don't
see that cache footprint should be increased.

TLB, perhaps, because of increased memory usage. But I would have
thought memory usage increase should be pretty miniscule.

