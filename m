Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXEYERy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXEYERy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXEYERq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:17:46 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbXEYERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:17:46 -0400
Date: Thu, 24 May 2007 21:17:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
Message-Id: <20070524211737.daa3c99c.akpm@linux-foundation.org>
In-Reply-To: <4656602A.3010000@drzeus.cx>
References: <4655834F.3050301@drzeus.cx>
	<20070524170654.5d674474.akpm@linux-foundation.org>
	<4656602A.3010000@drzeus.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 06:03:54 +0200 Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Andrew Morton wrote:
> > On Thu, 24 May 2007 14:21:35 +0200
> > Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> >
> >   
> >> +	/* wait for any asynchronous scanning to complete */
> >> +	if ((ROOT_DEV == 0) && root_wait) {
> >> +		printk(KERN_INFO "Waiting for root device %s...\n",
> >> +			saved_root_name);
> >> +		do {
> >> +			while (driver_probe_done() != 0)
> >> +				msleep(100);
> >> +			ROOT_DEV = name_to_dev_t(saved_root_name);
> >> +			if (ROOT_DEV == 0)
> >> +				msleep(100);
> >> +		} while (ROOT_DEV == 0);
> >> +	}
> >>     
> >
> > This seems overly complex.  Can't we simply do
> >
> >
> > 	while (driver_probe_done() || ROOT_DEV == 0)
> > 		msleep(100);
> >
> > ?
> >   
> 
> How would ROOT_DEV get updated in that loop?
> 

Whatever.  I think you can work it out ;)   

while (driver_probe_done() || (ROOT_DEV = name_to_dev_t(...)) == 0)

perhaps?

The loop-which-sleeps within a loop-which-sleeps seems poorly thought out?
