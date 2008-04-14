Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbYDNJQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbYDNJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYDNJQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:16:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYDNJQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:16:19 -0400
Date: Mon, 14 Apr 2008 11:16:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 git tree broken (bisected)
Message-ID: <20080414091600.GI19865@elte.hu>
References: <200804102159.14563.rjw@sisk.pl> <200804140010.01034.rjw@sisk.pl> <86802c440804131532g4626233br82a425d6a96a6e11@mail.gmail.com> <200804140219.07350.rjw@sisk.pl> <86802c440804131842t16d05976g20b2eb97af6bbf1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804131842t16d05976g20b2eb97af6bbf1b@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  Attached is dmesg output from current x86.git with 
> >  debug_gart_checking.patch applied.
> 
> please test the final one ... ...
> 
> You should get back 64M memory back.

so basically with all the right patches applied, and GART set to 32MB in 
the BIOS, Rafael should have more free RAM on his system than ever 
before :-)

i've put all the patches into x86.git/latest (it's all uploaded already 
as well), so that should give Rafael a one-stop shop to test it out. [i 
have not applied the debug patch that changes the aperture test from 
32MB to 64MB, and it should be unnecessary as well]

btw., Yinghai, should we perhaps add a WARN_ON() to those places where 
we waste RAM (such as the "This costs you 64 MB of RAM" message) - so 
that kerneloops.org can pick those warnings up? Maybe there are other 
situations where we waste RAM, and people dont realize it.

	Ingo
