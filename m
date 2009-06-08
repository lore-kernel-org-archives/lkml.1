Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZFHMDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZFHMDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZFHMDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:03:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:44182 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZFHMDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:03:32 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dR1805Mzz1202hzzz32i17ch6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKX5HL-01-LNU-01
Date: Mon, 8 Jun 2009 14:01:31 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Detect use of extended APIC ID for AMD
	CPUs
Message-ID: <20090608120131.GA8699@alberich.amd.com>
References: <20090604104016.GT5736@alberich.amd.com> <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org> <20090607153327.GA8973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090607153327.GA8973@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 Jun 2009 12:02:20.0326 (UTC) FILETIME=[F9C4AC60:01C9E830]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 05:33:27PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +	/* check CPU config space for extended APIC ID */
> > +	if (c->x86 >= 0xf) {
> > +		unsigned int val;
> > +
> > +		val = read_pci_config(0, 24, 0, 0x68);
> > +		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))
> > +			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
> > +	}
> > +#endif
> 
> It's possible to enable local APIC but not CONFIG_PCI - in that case 
> this sequence will fail to build.

Arrgh, thought that the stuff in early.c is always compiled in. Just
checked arch/x86/pci/Makefile showing
  obj-y                           += common.o early.o
and I didn't check arch/x86/Makefile which contains
  drivers-$(CONFIG_PCI)            += arch/x86/pci/

Sorry.
I'll send an updated patch.


Andreas


