Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbXCJJYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbXCJJYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbXCJJYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:24:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42400 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627AbXCJJYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:24:13 -0500
Subject: Re: [PATCH] dvb-core: Fix several locking related problems.
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Oberritter <obi@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-dvb@linuxtv.org
In-Reply-To: <20070310014959.GA4147@linuxtv.org>
References: <45DCB3A3.3060705@simon.arlott.org.uk>
	 <45E08886.50606@linuxtv.org> <45E08BFD.3080203@simon.arlott.org.uk>
	 <45E9D923.7040707@simon.arlott.org.uk> <45EAE894.1010000@linuxtv.org>
	 <45EB05D2.90608@simon.arlott.org.uk>  <20070310014959.GA4147@linuxtv.org>
Content-Type: text/plain; charset=utf-8
Date: Sat, 10 Mar 2007 07:23:57 -0200
Message-Id: <1173518637.9092.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sáb, 2007-03-10 às 02:49 +0100, Johannes Stezenbach escreveu:
> On Sun, Mar 04, 2007 at 05:45:54PM +0000, Simon Arlott wrote:
> > Fix several instances of dvb-core functions using mutex_lock_interruptible 
> > and returning -ERESTARTSYS where the calling function will either never 
> > retry or never check the return value.
> > 
> > These cause a race condition with dvb_dmxdev_filter_free and 
> > dvb_dvr_release, both of which are filesystem release functions whose 
> > return value is ignored and will never be retried. When this happens it 
> > becomes impossible to open dvr0 again (-EBUSY) since it has not been 
> > released properly.
> > 
> > Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> 
> Acked-By: Johannes Stezenbach <js@linuxtv.org>
> 
> I can't test this but to me it looks good.
> Mauro, could you please pick it up and keep it in the
> linuxtv.org repository for a while for testing?

Done.
Thanks, Johannes.

-- 
Cheers,
Mauro

