Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab0AOUBQ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139Ab0AOUBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:01:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53121 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab0AOUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:01:10 -0500
Date: Fri, 15 Jan 2010 21:01:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de,
        KMoorman@transy.edu, w.sang@pengutronix.de,
        ken_kawasaki@spring.nifty.jp, davem@davemloft.net,
        Andrew Morton <akpm@osdl.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: serial_cs: oxsemi quirk breaks resume
Message-ID: <20100115200100.GC1345@ucw.cz>
References: <20091110075410.GA6157@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110075410.GA6157@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-10 08:54:10, Pavel Machek wrote:
> 
> Quirk is applied on all cards with given manfid (is it that
> correct?). Unfortunately, that quirk breaks resume on zaurus with
> billionton bluetooth card inserted: c950ctrl is 0 and outb() faults.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

I believe this patch got enough acks and is waiting in the tree
somewhere (greg?) (possibly with slightly different changelog), but I
don't see it in 33-rc4. Could it get pushed? It is quite simple
bugfix, and is important for my zaurus...  Pavel

> --- a/drivers/serial/serial_cs.c	2009-10-06 13:51:46.000000000 +0200
> +++ b/drivers/serial/serial_cs.c	2009-11-09 14:43:25.000000000 +0100
> @@ -158,7 +158,8 @@
>  {
>  	struct serial_info *info = link->priv;
>  
> -	outb(12, info->c950ctrl + 1);
> +	if (info->c950ctrl)
> +		outb(12, info->c950ctrl + 1);
>  }
>  
>  /* request_region? oxsemi branch does no request_region too... */
> 
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
