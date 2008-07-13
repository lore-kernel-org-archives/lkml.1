Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYGMVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYGMVEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYGMVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:04:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909AbYGMVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:04:22 -0400
Date: Sun, 13 Jul 2008 14:03:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com, paul@pwsan.com,
       "David Brownell" <david-b@pacbell.net>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 1/3] genclk: add generic framework for managing clocks.
Message-Id: <20080713140352.5d81614c.akpm@linux-foundation.org>
In-Reply-To: <bc64b4640807131353j32487b90o645d2040e26ff6f0@mail.gmail.com>
References: <20080708134242.GA6176@doriath.ww600.siemens.net>
	<20080708134336.GA6240@doriath.ww600.siemens.net>
	<20080712234823.e632c7f9.akpm@linux-foundation.org>
	<bc64b4640807131353j32487b90o645d2040e26ff6f0@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 00:53:51 +0400 Dmitry <dbaryshkov@gmail.com> wrote:

> >  > +     list_del(&clk->priv.node);
> >  > +     kref_put(&clk->priv.ref, clk_release);
> >
> >
> > Might not be able to call kref_put(), either.
> 
> I'll move it outside of the spinlock. But tell me please, why?

Because the release handler might not like being called under
that lock.  I didn't check...
