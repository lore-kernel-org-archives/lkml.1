Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbZA2Xvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbZA2Xvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbZA2XvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:51:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756835AbZA2XvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:51:19 -0500
Date: Thu, 29 Jan 2009 15:50:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc
 instance is not found
Message-Id: <20090129155042.e0ea148d.akpm@linux-foundation.org>
In-Reply-To: <20090129174655.1f440f3e@hcegtvedt>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<20090129174655.1f440f3e@hcegtvedt>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 17:46:55 +0100
Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:

> On Mon, 19 Jan 2009 13:57:56 +0100
> Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> > This patch replaces the dev_dbg(...) with a pr_err since the ssc
> > pointer is not valid when the id is not found in the list.
> > 
> > Signed-off-by: Hans-Christian Egtvedt
> > <hans-christian.egtvedt@atmel.com> ---
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
> 
> Bump, or did I miss the merge window?
> 

(Top-posting repaired.  Please don't do that!  It makes it horrid to
reply to you)

(Suitable cc's added - this was why your patch got lost)

The patch seems reasonable but the changelog seems to be quite
misleading.  I did this:

   The ssc pointer is not valid when the id is not found in the
   list.  Convert the message from a debug one into an error message
   and avoid dereferencing the bad pointer.

OK?
