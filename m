Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYKDQ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYKDQ6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYKDQ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:58:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbYKDQ6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:58:42 -0500
Date: Tue, 4 Nov 2008 17:58:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104165811.GA1664@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu> <1225805399.25337.1282903253@webmail.messagingengine.com> <20081104140030.GA16178@elte.hu> <1225815789.30706.1282936457@webmail.messagingengine.com> <20081104164717.GD21470@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104164717.GD21470@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Alexander van Heukelum - Tue, Nov 04, 2008 at 05:23:09PM +0100]
> ...
> | 
> | I did some timings using the little program below (32-bit only), doing
> | 1024 times the same sequence. TEST1 is just pushing a constant onto
> | the stack; TEST2 is pushing the cs register; TEST3 is the sequence
> | from the patch to extract the vector number from the cs register.
> | 
> | Opteron    (cycles): 1024 / 1157 / 3527
> | Xeon E5345 (cycles): 1092 / 1085 / 6622
> | Athlon XP  (cycles): 1028 / 1166 / 5192
> 
> Xeon is defenitely out of luck :-)

it's still OK - i.e. no outrageous showstopper overhead anywhere in 
that instruction sequence. The total round-trip overhead is what will 
matter most.

	Ingo
