Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbXJQTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbXJQTua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbXJQTuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:50:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44388 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755728AbXJQTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:50:08 -0400
Date: Wed, 17 Oct 2007 21:50:36 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] hwmon/ibmpex.c: fix NULL dereference
Message-ID: <20071017195036.GC3778@stusta.de>
References: <20071017192902.GB3778@stusta.de> <29495f1d0710171239i30776a2ci6db65c4f135b0754@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29495f1d0710171239i30776a2ci6db65c4f135b0754@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 12:39:59PM -0700, Nish Aravamudan wrote:
> On 10/17/07, Adrian Bunk <bunk@kernel.org> wrote:
> > Don't dereference "data" when we know for sure it's NULL.
> >
> > Spotted by the Coverity checker.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > ---
> > 66bec2ef5c6d55fc30ef6ac5bb97fdfcfaf394f2
> > diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> > index c462824..e14ce3d 100644
> > --- a/drivers/hwmon/ibmpex.c
> > +++ b/drivers/hwmon/ibmpex.c
> > @@ -457,7 +457,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
> >         data = kzalloc(sizeof(*data), GFP_KERNEL);
> >         if (!data) {
> >                 printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
> > -                      "interface %d.\n", data->interface);
> > +                      "interface.\n");
> 
> Hrm but what data->interface would be is specified by the iface
> parameter? Just spit that out instead?

This is only a symptom of the problem that kzalloc() failed, and when 
you are getting into such a situation here you have bigger problems - 
and these are not related to this driver.

Feel free to send a different patch, but IMHO "Insufficient memory" 
alone is enough information in this case.

> Thanks,
> Nish

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

