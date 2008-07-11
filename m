Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYGKJAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYGKJAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYGKJAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:00:13 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:14468 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYGKJAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:00:11 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-8.tower-29.messagelabs.com!1215766810!18559457!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 11 Jul 2008 11:00:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080711090003.GA20108@digi.com>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se> <20080710065639.GA16794@digi.com> <20080710105850.GA3202@local> <aec7e5c30807110145s1106bb2bs60026400390e3de3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30807110145s1106bb2bs60026400390e3de3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Jul 2008 09:00:04.0224 (UTC) FILETIME=[8232F000:01C8E334]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Magnus Damm wrote:
> On Thu, Jul 10, 2008 at 7:58 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> > On Thu, Jul 10, 2008 at 08:56:39AM +0200, Uwe Kleine-König wrote:
> >> > +       ret = uio_register_device(&pdev->dev, priv->uioinfo);
> >> > +       if (ret) {
> >> > +               dev_err(&pdev->dev, "unable to register uio device\n");
> >> > +               goto bad1;
> >> > +       }
> >> > +
> >> > +       platform_set_drvdata(pdev, priv);
> >> This should probably go before uio_register_device.  (Uups, this is an
> >> issue for uio_pdrv, too.)
> >
> > Yes, because uio_register_device will enable the irq, and you might
> > arrive in the handler without having your platform data in place.
> 
> I'd say that this is a non-issue.
> 
> Only uio_pdrv_genirq_remove() is using the platform data. This
> remove() method won't be called if uio_pdrv_genirq_probe() returns
> failure. The UIO subsystem is using uioinfo->priv which of course is
> set up correctly already.
... let me check ... yes, it's true.  So it only looks ugly :-)

Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
