Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYEWK4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYEWK4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYEWK40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:56:26 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:49689 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYEWK40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:56:26 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-37.messagelabs.com!1211540184!1459109!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 23 May 2008 12:56:04 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Message-ID: <20080523105604.GA23800@digi.com>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080523120308.7bec1e1c@bluebox.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 May 2008 10:56:05.0216 (UTC) FILETIME=[99084600:01C8BCC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

Hans J. Koch wrote:
> Am Fri, 23 May 2008 11:10:09 +0200
> schrieb Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>:
> 
> > Hans J. Koch wrote:
> > > Am Fri, 23 May 2008 07:55:27 +0200
> > > schrieb Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>:
> > > 
> > > > Hello Hans,
> > > > 
> > > > > -      Copyright (c) 2006 by Hans-JÃŒrgen Koch.</para>
> > > > > +      Copyright (c) 2006-2008 by Hans-JÃŒrgen Koch.</para>
> > > > This looks wrong.
> > > 
> > > DocBook XML is supposed to be UTF-8.
> > Correct.  But still the problem is real.  The headers of your mail
> > claim the content to be encoded in UTF-8, but actually it's latin1.
> > So I cannot apply the patch you sent with git am without hand editing.
> 
> Try the version below.
This one is better---I can apply it.

> +	if (copy_from_user(&irq_on, buf, count))
> +		return -EFAULT;
> +
> +	if (!idev->info->irqcontrol)
> +		return -ENOSYS;
I would swap these two.  copy_from_user is more expensive than testing
idev->info->irqcontrol.  (Is it really?)  Anyhow only fetching a value
from userspace if you really need it looks more clean to me.

Otherwise the patch looks fine.

Uwe


-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
