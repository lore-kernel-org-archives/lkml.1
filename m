Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZLWBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZLWBFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZLWBFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:05:19 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42620 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZLWBFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:05:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 22 Dec 2009 17:05:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
In-Reply-To: <4B3123AA.8040205@gmail.com>
Message-ID: <alpine.DEB.2.00.0912221700230.29381@makko.or.mcafeemobile.com>
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <4B3115C1.4070303@redhat.com> <4B311ADA.4000700@gmail.com> <alpine.DEB.2.00.0912221137380.29381@makko.or.mcafeemobile.com>
 <4B3123AA.8040205@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Gregory Haskins wrote:

> On 12/22/09 2:39 PM, Davide Libenzi wrote:
> > On Tue, 22 Dec 2009, Gregory Haskins wrote:
> > 
> >> On 12/22/09 1:53 PM, Avi Kivity wrote:
> >>> I asked why the irqfd/ioeventfd mechanisms are insufficient, and you did not reply.
> >>>
> >>
> >> BTW: the ioeventfd issue just fell through the cracks, so sorry about
> >> that.  Note that I have no specific issue with irqfd ever since the
> >> lockless IRQ injection code was added.
> >>
> >> ioeventfd turned out to be suboptimal for me in the fast path for two
> >> reasons:
> >>
> >> 1) the underlying eventfd is called in atomic context.  I had posted
> >> patches to Davide to address that limitation, but I believe he rejected
> >> them on the grounds that they are only relevant to KVM.
> > 
> > I thought we addressed this already, in the few hundreds of email we 
> > exchanged back then :)
> 
> We addressed the race conditions, but not the atomic callbacks.  I can't
> remember exactly what you said, but the effect was "no", so I dropped it. ;)
> 
> This was the thread.
> 
> http://www.archivum.info/linux-kernel@vger.kernel.org/2009-06/08548/Re:_[KVM-RFC_PATCH_1_2]_eventfd:_add_an_explicit_srcu_based_notifier_interface

Didn't that ended up in schedule_work() being just fine, and no need was 
there for pre-emptible callbacks?



> >> 2) it cannot retain the data field passed in the PIO.  I wanted to have
> >> one vector that could tell me what value was written, and this cannot be
> >> expressed in ioeventfd.
> > 
> > Like might have hinted in his reply, couldn't you add data support to the 
> > ioeventfd bits in KVM, instead of leaking them into mainline eventfd?
> > 
> 
> Perhaps, or even easier I could extend xinterface.  Which is what I did ;)
> 
> The problem with the first proposal is that you would no longer actually
> have an eventfd based mechanism...so any code using ioeventfd (like
> Michael Tsirkin's for instance) would break.

At that point, the KVM eventfd can take care of thing so that Michael bits 
do not break.



- Davide


