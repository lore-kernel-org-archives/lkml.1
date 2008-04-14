Return-Path: <linux-kernel-owner+w=401wt.eu-S1764870AbYDNSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764870AbYDNSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbYDNSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:10:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:17963 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281AbYDNSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZvcsssFoBBpx+yDiwZ+WJcYXnl1zMnGdXAgdcE+omyMf4+Dt9qazP09pKJF4dP2PMed0amjSUgyXSU1Gn4usWjryGg87bTHtLKu2dfqQmzcPAXy9sEEFhqSNtyGmf2+fEsxTVsO43AAvqRAc+jJzSqIIP1a9BCC+4pOis97Q+rA=
Date: Mon, 14 Apr 2008 14:10:02 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wm97xx-core: Only schedule interrupt handler if
	not already scheduled
Message-ID: <20080414140832.ZZRA012@mailhub.coreip.homeip.net>
References: <20080414173841.GA2213@rakim.wolfsonmicro.main> <1208194775-4293-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208194775-4293-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Apr 14, 2008 at 06:39:33PM +0100, Mark Brown wrote:
>  static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
>  {
>  	struct wm97xx *wm = dev_id;
>  
> -	wm->mach_ops->irq_enable(wm, 0);
> -	queue_work(wm->ts_workq, &wm->pen_event_work);
> +	if (!work_pending(&wm->pen_event_work)) {
> +		wm->mach_ops->irq_enable(wm, 0);
> +		queue_work(wm->ts_workq, &wm->pen_event_work);
> +	}

Given the fact that work will not be queued if it is pending anyway
why is this change needed?

-- 
Dmitry
