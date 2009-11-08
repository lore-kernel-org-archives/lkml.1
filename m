Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZKHW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZKHW3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 17:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbZKHW3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 17:29:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:50983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbZKHW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 17:29:33 -0500
Date: Sun, 8 Nov 2009 14:30:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       jens.axboe@oracle.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-ID: <20091108143059.029abf8b@infradead.org>
In-Reply-To: <4e5e476b0911081359x32d7a6c4x61ee3af92dc0c8a1@mail.gmail.com>
References: <20090915054259.5282e5ba@infradead.org>
	<4e5e476b0911040139h1f471627la4262a5fa66abab0@mail.gmail.com>
	<20091108124035.23d53197@infradead.org>
	<4e5e476b0911081359x32d7a6c4x61ee3af92dc0c8a1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009 22:59:43 +0100
Corrado Zoccolo <czoccolo@gmail.com> wrote:
> >
> > the exit latency is +/- 1 us, the entry latency is similar, and then
> > you're pretty close to 5 already (esp if you keep in mind that to
> > break even on energy you also need to be in the C state for a
> > little bit)...
> 
> There are also performance considerations for using C1 (HLT).
> Quoting from http://www.intel.com/Assets/PDF/manual/248966.pdf (8-19):
> On processors supporting HT Technology, operating systems should use
> the HLT instruction if one logical processor is active and the other
> is not. HLT will allow an idle
> logical processor to transition to a halted state; this allows the
> active logical
> processor to use all the hardware resources in the physical package.

I think we all agree that long term polling is bad ;-)
(even though we use rep nop in the polling loop which is also a HT
yield).

There's just the very short sleeps (where short is "single digit usecs")
where the rules are slightly different.

> > this check is supposed to catch the known timer cases; those
> > are rather accurate in prediction
> 
> Unfortunately, I have seen polling residency times > 1ms, so it must
> not be so accurate.

well the question is... is this a measurement error or an error in
when polling is chosen.
We obviously need to fix it whatever it is, but... first need to chase
down really which it is.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
