Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbZJBSrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbZJBSrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZJBSrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:47:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbZJBSrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:47:39 -0400
Date: Fri, 2 Oct 2009 20:47:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: carve out AMD MCE decoding logic
Message-ID: <20091002184714.GA21509@elte.hu>
References: <20091001141432.GA11410@aftab> <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain> <20091001144637.GB11410@aftab> <20091001150046.GA21476@elte.hu> <20091001152140.GC11410@aftab> <20091001153250.GA25885@elte.hu> <20091002132101.GA28682@aftab> <20091002133148.GD28682@aftab> <20091002133954.GA29390@elte.hu> <20091002182659.GA16436@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002182659.GA16436@aftab>
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> On Fri, Oct 02, 2009 at 03:39:54PM +0200, Ingo Molnar wrote:
> > I suspect this is fine currently because no two EDAC modules should be 
> > active at the same time. A followup cleanup patch would be nice 
> > nevertheless that uses a notifier chain here with proper 
> > register/unregister locking.
> 
> Please do elaborate for I can't seem to follow.
> 
> AFAICT, we are going to have max one MCE decoder at any one time so no 
> need to notify it.
> 
> The x86_mce_decode_callback assignment probably needs locking just to 
> be on the safe side. We can do a
> 
> mce_set_decode_callback(void (*f)(struct mce*m))
> 
> helper which falls back to default_decode_mce() whenever its being 
> passed a NULL for *f using proper locking...
> 
> I'm pretty sure I'm missing something though...

No, the locking was all that i meant. Using atomic_notifier would solve 
that. Make the default decoder low-prio, that way there's no need to do 
the callback save/restore sequence either.

	Ingo
