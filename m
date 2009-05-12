Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZELJ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZELJ0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZELJ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:26:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44273 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZELJ0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:26:10 -0400
Date: Tue, 12 May 2009 11:26:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Message-ID: <20090512092601.GB29796@elte.hu>
References: <20090511222702.352192505@arndb.de> <200905112319.17999.arnd@arndb.de> <20090512075513.GA14122@elte.hu> <200905121104.31275.arnd@arndb.de> <20090512091010.GD18004@elte.hu> <20090512102105.291afe53@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512102105.291afe53@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > hm, on x86 you could use get_user_try / get_user_ex() / 
> > get_user_catch() approach to linearize the dependencies and 
> > reduce register pressure.
> 
> It used *once*, in a path that is never executed except by some 
> ancient binaries. It isn't worth the effort.

i know, and i tested the patch so i know what effects it has.

I never made any argument about inlining, it's obviously correct to 
have a use-once function inline.

My argument was very simple: the patch causes +150 bytes of bloat. 
The try/ex/catch method can help reduce register pressure and can 
reducethe size of code quite visibly.

	Ingo
