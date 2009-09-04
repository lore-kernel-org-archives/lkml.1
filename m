Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZIDFM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZIDFM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZIDFM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:12:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZIDFM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:12:28 -0400
Date: Fri, 4 Sep 2009 07:12:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
	is cache aligned
Message-ID: <20090904051202.GA25714@elte.hu>
References: <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com> <4AA080A0.7010804@kernel.org> <4AA08283.5020306@kernel.org> <4AA08B09.50503@zytor.com> <4AA08DD3.5010509@kernel.org> <4AA08ED0.4050206@zytor.com> <4AA0A05B.5010806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA0A05B.5010806@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> H. Peter Anvin wrote:
> > On 09/03/2009 08:47 PM, Tejun Heo wrote:
> >> H. Peter Anvin wrote:
> >>> On 09/03/2009 07:59 PM, Tejun Heo wrote:
> >>>> Another question.  Other than saving and loading an extra segment
> >>>> register on kernel entry/exit, whether using the same or different
> >>>> segment registers doesn't look like would make difference
> >>>> performance-wise.  If I'm interpreting the wording in the optimization
> >>>> manual correctly, it means that each non-zero segment based memory
> >>>> access will be costly regardless of which specific segment register is
> >>>> in use and there's no way we can merge segment based dereferences for
> >>>> stackprotector and percpu variables.
> >>>>
> >>> It's correct that it doesn't make any difference for access, only for load.
> >> Heh... here's a naive and hopeful plan.  How about we beg gcc
> >> developers to allow different segment register and offset in newer gcc
> >> versions and then use the same one when building with the new gcc?
> >> This should solve the i386 problem too.  It would be the best as we
> >> get to keep the separate segment register from the userland.  Too
> >> hopeful?
> > 
> > I think it's possible to set the register in more recent gcc.  
> > Doing the sane thing and having a symbol for an offset is 
> > probably worse.
> 
> I was thinking about altering the build process so that we can use 
> sed to substitute %gs:40 with %fs:40 while compiling.  If it's 
> already possible to override the register in more recent gcc, no 
> need to go into that horror.
> 
> > I can talk to H.J. Lu about this tomorrow.
> 
> Great, please keep us posted.

Yeah - if then this should definitely be handled in the compiler.

	Ingo
