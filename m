Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYGCL73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYGCL73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYGCL5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:57:09 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:53467 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbYGCL5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:57:05 -0400
Subject: Re: x86_64: tss_struct layout does not match comments  !?
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <20080703113925.GA5594@elte.hu>
References: <1215082049.3026.15.camel@castor.localdomain>
	 <20080703113925.GA5594@elte.hu>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 12:57:01 +0100
Message-Id: <1215086221.3026.16.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-03 at 13:39 +0200, Ingo Molnar wrote:
> * Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> 
> > Hi Ingo,
> > 
> > the comments in the definition of tss_struct suggests is should be
> > cacheline aligned ( or 256 byte aligned ? ) :- 
> > 
> > |struct tss_struct {
> > |....
> > |	/*
> > |	 * Pad the TSS to be cacheline-aligned (size is 0x100):
> > |	 */
> > |	unsigned long		__cacheline_filler[35];
> > |	/*
> > |	 * .. and then another 0x100 bytes for the emergency kernel stack:
> > |	 */
> > |	unsigned long		stack[64];
> > |
> > |} __attribute__((packed));
> > 
> > However on a 64 bit build the size of tss_struct is 9136,
> > cacheline_filler is 280 and stack size is 512 at offset 8624.
> > None of which are cacheline aligned.
> > 
> > I'm guessing this isn't what was intended.
> > 
> > do you know what the original intention was ?
> > 
> > 1. struct tss_struct{...} __cacheline_aligned;
> > or just
> > 2. struct tss_struct {
> > ...
> > long stack[64] __cacheline_aligned;
> > }
> 
> #1 is the intent - because each CPU has a separate TSS. init_tss.stack 
> is really just an emergency static stack we have in place for very early 
> exceptions.
> 
> i think the __cacheline_filler could be removed safely. Mind sending a 
> patch for that?
> 
> 	Ingo

No problem.
Richard 

