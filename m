Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYCKGgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYCKGgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYCKGgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:36:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:47514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbYCKGgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:36:41 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] fix ACPI boot regression (was: Re: Linux 2.6.25-rc5)
Date: Tue, 11 Mar 2008 02:04:31 -0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <alpine.LFD.1.00.0803092231580.5896@woody.linux-foundation.org> <alpine.LFD.1.00.0803101011580.5896@woody.linux-foundation.org> <20080310172417.GA25898@elte.hu>
In-Reply-To: <20080310172417.GA25898@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110204.31709.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, 10 Mar 2008, Ingo Molnar wrote:
> > >
> > > so zero-extending the result in the PCI-BIOS read routine fixes the 
> > > regression on my laptop. ( It might fix some other long-standing 
> > > issues we had with PCI-BIOS during the past decade ... ) Both 8-bit 
> > > and 16-bit accesses were buggy.
> > 
> > Oh, wow. That must have been there forever, but very few people 
> > probably ever cared.
> > 
> > And why is your laptop using the BIOS routines anyway? Or was that 
> > just a result of your randconfig having turned off the sane config 
> > access routines?
> 
> yeah, randconfig generated this:
> 
>   CONFIG_PCI=y
>   CONFIG_PCI_GOBIOS=y
>   # CONFIG_PCI_GOMMCONFIG is not set
>   # CONFIG_PCI_GODIRECT is not set
>   # CONFIG_PCI_GOANY is not set
>   CONFIG_PCI_BIOS=y
> 
> which forced the PCI code into the BIOS access method on this otherwise 
> modern system. I disable some of the really-known-to-be-broken .config 
> options in randconfig - but i still bravely keept CONFIG_GO_PCIBIOS in 
> the randomized space, which triggered this.
> 
> On another box, which has a different BIOS, this bug never happened, in 
> tens of thousands of bootup tests.

I think this re-enforces three Axioms

1. Ingo rules!
2. Even the most obvious fix carries some risk
3. The more config options we maintain, the more fragmented is our test coverage.

thanks Ingo,
-Len

