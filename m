Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbXLTVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbXLTVyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXLTVx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:53:57 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:19905 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbXLTVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h/CJtRGrHlsuNJjW4FVMyJBHvocG7LlF/pIKUtIy1E7MHLnNYr9Tkfnqm4xOEjEK8y7q/sNcjmcHmRUyZuKtvORszn/zzuBavN+VJOA97ZDfn/6oAOf/6nzdZDId9bI4Dwq3vYj6bSPK+3OGP8jwpbzo6+3a+GbBTiQ+daCJ+yE=
Message-ID: <8b67d60712201353y71a85498p9d77f1f21761856c@mail.gmail.com>
Date: Thu, 20 Dec 2007 21:53:54 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Adrian McMenamin" <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
In-Reply-To: <20071216095019.GA12184@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
	 <20071216095019.GA12184@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/2007, Paul Mundt <lethal@linux-sh.org> wrote:

>
> Also, __devinit/__devexit annotations?
>

Is there any difference between __init and __devint? I am using
__init/__exit already

> > +static struct platform_driver gdrom_driver = {
> > +     .probe = probe_gdrom,
> > +     .remove = remove_gdrom,
>
> __devexit_p()?
>
> > +static void __exit exit_gdrom(void)
> > +{
> > +     blk_cleanup_queue(gd.gdrom_rq);
> > +     free_irq(HW_EVENT_GDROM_CMD, &gd);
> > +     free_irq(HW_EVENT_GDROM_DMA, &gd);
> > +     del_gendisk(gd.disk);
> > +     if (gdrom_major)
> > +             unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
> > +     platform_device_unregister(pd);
> > +     platform_driver_unregister(&gdrom_driver);
> > +     if (gd.toc)
> > +             kfree(gd.toc);
> > +}
> > +
> Ah, here's where you do the rest of the cleanup. This is non-intuitive,
> remove should balance the work done by probe and exit the work done by
> init.
>
