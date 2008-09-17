Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYIQKxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYIQKxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIQKw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:52:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbYIQKw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:52:57 -0400
Date: Wed, 17 Sep 2008 12:52:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080917105238.GF18764@elte.hu>
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <20080909002055.GA8573@yantp.cn.ibm.com> <48C5C47F.5040004@zytor.com> <20080916133239.GA17456@yantp.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916133239.GA17456@yantp.cn.ibm.com>
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


* Yan Li <elliot.li.tech@gmail.com> wrote:

> On Mon, Sep 08, 2008 at 05:34:07PM -0700, H. Peter Anvin wrote:
> >> VMware may change the PCI ID at their will so I prefer checking the
> >> DMI since it's easier.
> >>
> >> So if we ditched the official method we run the risk of some false
> >> negatives.  But checking the DMI manufacturer would be good enough.
> >>
> >
> > If we get false negatives that is quite frankly their problem, not ours.  
> >  If nothing else, we should be able to look for a host bridge with the  
> > VMWare vendor ID -- that should arguably be safer than DMI.
> 
> I found that in this situation we can't use PCI info.  My intention to
> do this is to fix the false warning from
> arch/x86/kernel/cpu/mtrr/main.c (around L695). When booting a VMware
> guest we got:
> "WARNING: strange, CPU MTRRs all blank?"
> 
> For VMware guest this warning is false, just as that for a KVM guest.
> 
> This code is from mtrr_trim_uncached_memory(), and used by
> setup_arch(), which is used far before PCI is ready.
> 
> Therefore I think we can only use DMI here. Any idea?

PCI quirks can be used almost arbitrarily early stage, see:
arch/x86/kernel/early-quirks.c.

Adding a VM identification callback to early-quirks.c would be fine. But 
if there's a reliable and specific enough DMI string that's fine as 
well. (but PCI is better, since it's a generally more stable enumeration 
interface)

	Ingo
