Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYJTHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYJTHyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYJTHx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:53:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYJTHx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:53:57 -0400
Date: Mon, 20 Oct 2008 09:53:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, maluta_tiago@yahoo.com.br,
       lguest@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [Lguest] lguest: unhandled trap
Message-ID: <20081020075333.GC798@elte.hu>
References: <713731.28571.qm@web50701.mail.re2.yahoo.com> <200810201452.04932.rusty@rustcorp.com.au> <20081020072236.GD12131@elte.hu> <48FC36B9.6000704@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC36B9.6000704@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> i think Xen can withstand DMI scanning just fine.
>>
>> without having seen any background, my general feeling is that lguest 
>> should either do what Xen does and reserve the classic BIOS ranges 
>> that we probe - or we should make DMI scanning more robust by making 
>> sure real RAM ranges are never probed. (only ranges that the BIOS 
>> itself marks as reserved in the e820 map)
>
> We considered doing that, but decided that there was so many other 
> pieces of code around the place that assume that the ISA area is 
> special, that just reserving it was the best course of action.

yeah - for _any_ virtual machine environment it's beneficial to look as 
much like a normal PC as possible, because normal PCs is where the code 
gets tested most.

Nevertheless if this is the only current roadblock for lguest then i 
wouldnt find it objectionable to make DMI scanning more robust that way 
- the two are complimentary. [ With an initial transitionary period of 
generating printks and WARN()s when we try to scan general RAM areas. ]

	Ingo
