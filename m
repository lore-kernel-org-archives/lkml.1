Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbXLSTjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbXLSTjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbXLSTj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:39:28 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:33717 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbXLSTj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:39:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dhUdW/qbxqiH1vLxeO9j2tBzpVBOQbJEtLIZ3rhLa18LHkWzadFU16PemBmzLK4hQrxZjQDLBsUSZ2GupgYx+rLr5MEhYXcWtB8LndNeSSldLYr9g8gl3nwlK0zwk7IpX0qp/k6Enl4TUf1dWPjHJQwRMv26A4PFiBkcKHf6Q9o=
Message-ID: <82e4877d0712191139k4dbae463icf2a59c8c0104010@mail.gmail.com>
Date: Wed, 19 Dec 2007 14:39:25 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] e1000: Use deferrable timer for watchdog
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <47696AC9.90204@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712182040470.3616@mini.warudkars.net>
	 <47696AC9.90204@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/07, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
[snip]

> I can't possibly see any benefit from this other than that you just add up to a
> whole second to the initialization cycle, which is bad.
>
Well, Ok but it can't be bad - I've been using this patch sometime and
haven't seen any problem at all and powertop shows it reduces the
wakeups-from-idle.

But whatever - no big deal since it already uses round_jiffies().

Parag

> >
> > Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
> >
> > --- linux-2.6/drivers/net/e1000/e1000_main.c    2007-12-07
> > 10:04:39.000000000 -0500
> > +++ linux-2.6-work/drivers/net/e1000/e1000_main.c    2007-12-18
> > 20:38:38.000000000 -0500
> > @@ -1030,7 +1030,7 @@
> >      adapter->tx_fifo_stall_timer.function = &e1000_82547_tx_fifo_stall;
> >      adapter->tx_fifo_stall_timer.data = (unsigned long) adapter;
> >
> > -    init_timer(&adapter->watchdog_timer);
> > +    init_timer_deferrable(&adapter->watchdog_timer);
> >      adapter->watchdog_timer.function = &e1000_watchdog;
> >      adapter->watchdog_timer.data = (unsigned long) adapter;
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe netdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
