Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZIWRk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZIWRk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZIWRk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:40:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58381 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbZIWRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:40:25 -0400
Date: Wed, 23 Sep 2009 19:39:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
       Elina Pasheva <epasheva@sierrawireless.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] USB sierra: Fix build if
	!CONFIG_PM
Message-ID: <20090923173944.GA20549@elte.hu>
References: <20090923135539.GA6542@kroah.com> <20090923172456.GA8948@elte.hu> <4ABA5BBB.2040804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA5BBB.2040804@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Ingo Molnar wrote:
> >>       USB: support for autosuspend in sierra while online
> > 
> > FYI, -tip testing found a build failure with the sierra driver on 
> > !CONFIG_PM - fixed via the patch below.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > -------------------->
> > From 26f8ed899041199caa9315e057a28d10f81b5b88 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Wed, 23 Sep 2009 19:19:47 +0200
> > Subject: [PATCH] USB sierra: Fix build if !CONFIG_PM
> > 
> > This build failure:
> > 
> >   drivers/usb/serial/sierra.c: In function 'sierra_suspend':
> >   drivers/usb/serial/sierra.c:936: error: 'struct usb_device' has no member named 'auto_pm'
> > 
> > Triggers because the ->auto_pm functionality depends on CONFIG_PM.
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Ack.
> http://marc.info/?l=linux-usb&m=125305135600816&w=2
> 
> lossy. :(

yeah, indeed.

Btw., i think my patch is a bit better as it also includes 
stop_read_write_urbs() in the #ifdef block - your patch would probably 
trigger a 'defined but not used' compiler warning. (have not checked 
though.)

	Ingo
