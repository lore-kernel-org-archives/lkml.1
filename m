Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYDIIzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYDIIzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYDIIyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:54:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYDIIyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:54:54 -0400
Date: Wed, 9 Apr 2008 10:54:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Zhao Forrest <forrest.zhao@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080409085440.GB32466@elte.hu>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org> <20080409083700.GU3700@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409083700.GU3700@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Matti Aarnio <matti.aarnio@zmailer.org> wrote:

> On Wed, Apr 09, 2008 at 10:01:59AM +0200, Andi Kleen wrote:
> > "Zhao Forrest" <forrest.zhao@gmail.com> writes:
> > >
> > > As we can see from above information that the physical memory in system
> > > is 32768MB(32GB). However OS is only using about
> > > (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
> > > linux kernel can't use the physical memory remapped
> > > from (4G-512M, 4G) to (32G, 32G+512M)?
> > 
> > The linux kernel can only use the memory passed to it by the BIOS.
> > Sometimes they need special BIOS setup options to enable remapping. If
> > there are no such options and you can't upgrade it you're out of luck
> > 
> > I would suggest you contact your system vendor.
> 
> I second that.  On my home machine I have early ASUS AMD x64 board 
> from a few years ago.  For it I did buy CPU with this memory mapping 
> hardware inside, but the BIOS did not support it correctly until a 
> year or two latter, thus I was not able to use all of 4 GB of memory I 
> had installed there. There was support in BIOS from start, but it did 
> things wrong.

having said that - but we'll still consider sane looking patches that 
allow the remapping of otherwise inactive RAM. [ We might not even have 
to touch the system chipset beyond what Linux already knows about it: in 
theory someone might want to try a hack to GART remap such RAM areas and 
use a sparse mem map entry to map it to Linux - if the identity of that 
RAM is crystal-clear and there's enough GART space available. But even 
then it's probably still at best a dangerous and fragile hack. ]

	Ingo
