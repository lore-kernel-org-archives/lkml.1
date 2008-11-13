Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbYKMWFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbYKMWFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYKMWFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:05:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYKMWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:05:20 -0500
Date: Thu, 13 Nov 2008 23:05:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
Message-ID: <20081113220503.GA15109@elte.hu>
References: <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <20081110015511.453a801e.akpm@linux-foundation.org> <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu> <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu> <491C8B38.9060901@kernel.org> <20081113131850.d94fb229.akpm@linux-foundation.org> <86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:


> >> +     /*
> >> +      * We have to do the hash-walk again, to avoid races
> >> +      * with another CPU:
> >> +      */
> >> +     list_for_each_entry(desc, hash_head, hash_entry)
> >> +             if (desc->irq == irq)
> >> +                     goto out_unlock;

should be:

> >> +     list_for_each_entry(desc, hash_head, hash_entry) {
> >> +             if (desc->irq == irq)
> >> +                     goto out_unlock;
> >> +     }

and:

> >> +     desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
> >
> > Oh for gawd's sake.  PLEASE read Documentation/SubmitChecklist. 
> > Carefully.  We've already discussed this.
> >
> > You cannot do a GFP_KERNEL allocation under spin_lock_irqsave().

yes.

	Ingo
