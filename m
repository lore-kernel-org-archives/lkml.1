Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYKRPHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYKRPHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYKRPHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:07:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbYKRPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:07:16 -0500
Date: Tue, 18 Nov 2008 16:06:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Philipp Kohlbecher <xt28@gmx.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: alternative identifier for Phoenix BIOS
Message-ID: <20081118150659.GF30358@elte.hu>
References: <491EEDE8.5080508@gmx.de> <491F7D88.7080403@zytor.com> <20081116111447.23fbfe7e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116111447.23fbfe7e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sat, 15 Nov 2008 17:55:20 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Philipp Kohlbecher wrote:
> > > My laptop (a Samsung X20) contains a Phoenix BIOS and would benefit from
> > > patch 1e22436eba84edfec9c25e5a25d09062c4f91ca9 (x86: reserve low 64K on
> > > AMI and Phoenix BIOS boxen).
> > > 
> > > However, according to /sys/class/dmi/id/bios_vendor, the BIOS identifies
> > > its vendor as "Phoenix Technologies LTD" (sans the comma).
> > 
> > Given that AMI and Phoenix combined is something like 80% of the BIOS
> > market, if not more, it might simply be easier to make it unconditional,
> >  or make it a whitelist instead.
> 
> Far more useful would be to make people aware of the problem. If the 
> BIOS is scribbling in the low 64K of RAM not just BIOS areas, and 
> doing so outside of ACPI marked areas they need to fix the BIOS 
> ASAP. If they leave their BIOSes randomly scribbling in operating 
> system memory areas then as with previous (hardware related) cases 
> of vendors knowingly shipping corrupting equipment they'll be 
> building up a huge class action legal liability.
> 
> As such making sure the vendor knows in a way they cannot deny is a 
> very useful activity.

CONFIG_X86_CHECK_BIOS_CORRUPTION=y will do that, it prints:

  Corrupted low memory at 0x1000 (4096 phys) = 0x1234
  Memory corruption detected in low memory
  < stack trace >

if enough distros turn it on (at least in their debug kernels) it 
creates the right kind of user pressure.

This debug feature to catch BIOS-generated low-memory corruption is 
already upstream.

	Ingo
