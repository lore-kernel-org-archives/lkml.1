Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYGCN15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYGCN15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYGCN1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:27:49 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:48374 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYGCN1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:27:48 -0400
Date: Thu, 3 Jul 2008 13:39:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86_64: tss_struct layout does not match comments  !?
Message-ID: <20080703113925.GA5594@elte.hu>
References: <1215082049.3026.15.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215082049.3026.15.camel@castor.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.1 required=5.9 tests=BAYES_00,PLING_QUERY autolearn=no SpamAssassin version=3.2.3
	1.4 PLING_QUERY            Subject has exclamation mark and question mark
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> Hi Ingo,
> 
> the comments in the definition of tss_struct suggests is should be
> cacheline aligned ( or 256 byte aligned ? ) :- 
> 
> |struct tss_struct {
> |....
> |	/*
> |	 * Pad the TSS to be cacheline-aligned (size is 0x100):
> |	 */
> |	unsigned long		__cacheline_filler[35];
> |	/*
> |	 * .. and then another 0x100 bytes for the emergency kernel stack:
> |	 */
> |	unsigned long		stack[64];
> |
> |} __attribute__((packed));
> 
> However on a 64 bit build the size of tss_struct is 9136,
> cacheline_filler is 280 and stack size is 512 at offset 8624.
> None of which are cacheline aligned.
> 
> I'm guessing this isn't what was intended.
> 
> do you know what the original intention was ?
> 
> 1. struct tss_struct{...} __cacheline_aligned;
> or just
> 2. struct tss_struct {
> ...
> long stack[64] __cacheline_aligned;
> }

#1 is the intent - because each CPU has a separate TSS. init_tss.stack 
is really just an emergency static stack we have in place for very early 
exceptions.

i think the __cacheline_filler could be removed safely. Mind sending a 
patch for that?

	Ingo
