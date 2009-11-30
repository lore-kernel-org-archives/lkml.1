Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZK3VAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZK3VAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZK3VAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:00:05 -0500
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:48605 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752709AbZK3VAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:00:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tXsD+3Yo59Gu21FGTE+7GJIYgLaJh+rZDEkbUFklsLlpKCTkIV0JG2ee5D4GgthQouAug51wgAd2Vw7QttkPtQZOpT2nt0rHl54pfEq8YmJ84gCXTKNY8FfC+ZaLR4mbbuVG1KyeoaVk5rJY0oZBfTaW9tMccAr1QhsV90nCois=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: 9bRd1xkVM1kWGU_gUDSJpq7Ih7eBwsvYgLnSQkqTuEUZ3eTtiKbuJutikhyTB0nIph3KojGTwxnWKYy.UB2FA5jUJyyqysWiNqhoLJD4e4mtslUG.lyhnR0PwPyn9BUxJJIRaLX62nbx9IY.whaFNij3dX4ydNG1SYjTn3cniBhjQtKLc43GF3ylXLejdVv_taro3dv444KQK8YPdVzgORTAsKcctsm1UC89DPThLp0pKBW5n4JJM1ONbCpWhJ2w
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about IRQF_SHARED|IRQF_DISABLED)
Date: Mon, 30 Nov 2009 12:38:35 -0800
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain> <20091130144702.14bea0ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20091130144702.14bea0ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911301238.35750.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 November 2009, Alan Cox wrote:
> SHARED|DISABLED ought to WARN_ON() and if that doesn't motivate people
> then return -EINVAL. And with any luck that'll prove 6 months later that
> most of the offenders are not used and we can delete them wholesale.

So ... merge an updated version of the original patch, to
get full WARN coverage?

We've had that warning for a long time now.  The original
patch just covered non-request_irq() cases.  So by your
timetable we're ready for the "return -EINVAL" stage of
the migration... at least, for request_irq() callers.




