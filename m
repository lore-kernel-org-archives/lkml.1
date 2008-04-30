Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbYD3Tww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbYD3Tww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521AbYD3Twi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:52:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbYD3Twh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:52:37 -0400
Date: Wed, 30 Apr 2008 16:52:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: mkrufky@linuxtv.org
Cc: bunk@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080430165214.10b793b4@gaivota>
In-Reply-To: <4818C91E.8070307@linuxtv.org>
References: <20080430192829.GF29330@cs181133002.pp.htv.fi>
	<4818C91E.8070307@linuxtv.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 15:31:42 -0400
mkrufky@linuxtv.org wrote:

> > Are there actually reports from users running into this problem?

No.

Yet, the configuration may be valid. If you have a board with tda8290, it
_will_ need another chip, like tda827x.

In the past, both tda8290 and tda827x were handled by the same driver, and
worked for analog only.

So, IMO, this is a regression.

> >> Maybe, we
> >> may just do:
> >> obj-y += /dvb
> >> ...
> >>       
> >
> > Do DVB_TDA827X/DVB_TDA18271 need anything from DVB_CORE?
> >
> > If yes you'd only transform one build error into another.  
> 
> DVB_TDA827X and DVB_TDA18271 do not need anything from DVB_CORE -- their 
> only dependency is I2C_CORE.
> 
> I think Mauro renamed those Kconfig symbols to MEDIA_TUNER_TDAfoo now, btw.

I can't foresee any issues with those drivers. The risk I can see is to compile
some dvb core things that aren't needed, or whose Kconfig dependencies may be
incomplete.

I didn't make yet a deeper analysis to be sure that this won't cause any issues,
but I suspect that this would be safe.

I agree that we need to check the resulting dependencies.

Cheers,
Mauro
