Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZA3Jh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZA3Jh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZA3JhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:37:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbZA3JhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:37:10 -0500
Date: Fri, 30 Jan 2009 01:36:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       kay.sievers@vrfy.org, weiyi.huang@gmail.com,
       Andrew Victor <avictor.za@gmail.com>
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc
 instance is not found
Message-Id: <20090130013628.4672215d.akpm@linux-foundation.org>
In-Reply-To: <20090130102654.10e4aafc@hskinnemoen-d830>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<20090130102654.10e4aafc@hskinnemoen-d830>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 10:26:54 +0100 Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> [CCs added]
> 
> Hans-Christian Egtvedt wrote:
> > This patch replaces the dev_dbg(...) with a pr_err since the ssc pointer
> > is not valid when the id is not found in the list.
> > 
> > Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> 
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> 
> ...or should I just apply it to the avr32 tree?
> 

Is OK, I tossed into onto my 2.6.29 pile.

Should it be backported to 2.6.28.x or earlier?

> 
> > ---
> >  drivers/misc/atmel-ssc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
> > index 6b35874..6cff1bb 100644
> > --- a/drivers/misc/atmel-ssc.c
> > +++ b/drivers/misc/atmel-ssc.c
> > @@ -35,7 +35,7 @@ struct ssc_device *ssc_request(unsigned int ssc_num)
> >  
> >  	if (!ssc_valid) {
> >  		spin_unlock(&user_lock);
> > -		dev_dbg(&ssc->pdev->dev, "could not find requested device\n");
> > +		pr_err("ssc: ssc%d platform device is missing\n", ssc_num);
> >  		return ERR_PTR(-ENODEV);
> >  	}
> >  
