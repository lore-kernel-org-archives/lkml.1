Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZA3Jvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZA3Jvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZA3Jvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:51:45 -0500
Received: from relay.atmel.no ([80.232.32.139]:60461 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZA3Jvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:51:44 -0500
Date: Fri, 30 Jan 2009 10:50:57 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       kay.sievers@vrfy.org, weiyi.huang@gmail.com,
       Andrew Victor <avictor.za@gmail.com>
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc
 instance is not found
Message-ID: <20090130105057.7d0acaec@hcegtvedt>
In-Reply-To: <20090130013628.4672215d.akpm@linux-foundation.org>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<20090130102654.10e4aafc@hskinnemoen-d830>
	<20090130013628.4672215d.akpm@linux-foundation.org>
Organization: Atmel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 01:36:28 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 30 Jan 2009 10:26:54 +0100 Haavard Skinnemoen
> <haavard.skinnemoen@atmel.com> wrote:
> 
> > [CCs added]
> > 
> > Hans-Christian Egtvedt wrote:
> > > This patch replaces the dev_dbg(...) with a pr_err since the ssc
> > > pointer is not valid when the id is not found in the list.
> > > 
> > > Signed-off-by: Hans-Christian Egtvedt
> > > <hans-christian.egtvedt@atmel.com>
> > 
> > Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> > 
> > ...or should I just apply it to the avr32 tree?
> > 
> 
> Is OK, I tossed into onto my 2.6.29 pile.
> 
> Should it be backported to 2.6.28.x or earlier?
> 

It shoud apply clean to 2.6.28.x as well, but this bug will only
trigger when a user of the SSC peripheral tries to request a SSC which
is already requested or not added to the list at all. So in most cases
bad platform drivers setup, configuration error or bad code.

In kernel 2.6.29-rc3 there are three users:

1 sound/soc/atmel/sam9g20_wm8731.c        274 ssc = ssc_request(0);
2 sound/soc/atmel/playpaq_wm8510.c        399 ssc = ssc_request(0);
3 sound/spi/at73c213.c                    980 chip->ssc = ssc_request(board->ssc_id);

The two first are a bit suspicious since they hard code id 0.

My 0.02 € is to get it in for 2.6.29, but fine to leave out for earlier
kernels.

-- 
Best regards,
Hans-Christian Egtvedt
