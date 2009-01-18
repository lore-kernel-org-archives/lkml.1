Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZARTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZARTJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZARTJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:09:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42670 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZARTJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:09:05 -0500
Date: Sun, 18 Jan 2009 20:08:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: Mike Travis <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86: put trigger in to detect mismatched apic versions.
Message-ID: <20090118190849.GB858@elte.hu>
References: <49704DF6.8040205@sgi.com> <20090116092540.GC4305@elte.hu> <4970C984.30202@sgi.com> <20090116223011.GB3899@elte.hu> <497116A8.5080900@sgi.com> <20090117030752.GB127262@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117030752.GB127262@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> > Btw, I checked with our UV architect and the problem is that we need a 
> > 16 bit apic id which is what caused the MAX_APICS to be bumped to 32k. 
> > The lower 8 bits are the normal apic id, and the upper bit relate to 
> > the node.  This means cpu 0 on node 0 has the same apic id as cpu 0 on 
> > node 1, etc.  I also asked about whether we could rely on always 
> > having
> 
> Not strictly true. The apicids in the ACPI tables are always globally 
> unique across the entire system. Because of the size of UV systems, UV 
> needs 16 bit apicids. This fits in the ACPI apicid id/eid fields.
> 
> The actual processor apicid register is unfortunately only 11 bits and 
> there are some restrictions on the actual values loaded into the apicid 
> register.
> 
> If we can put unique ids into the apicid register, we do. If we can't, 
> the function that reads the apicid will automatically supply the rest of 
> the bits.  Most of the kernel is unaware that the processor apicid 
> register may have only a subset of the bits that are in the ACPI tables.

apicid remapping is something we need/want, so we cannot remove that 
array. But it would be nice to offload such properties to the percpu area 
instead - is there any reason why that is hard? The local apic is attached 
to a CPU in any case. Is there some early init reason that complicates 
this?

	Ingo
