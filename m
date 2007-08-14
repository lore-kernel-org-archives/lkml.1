Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbXHNORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbXHNORR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXHNORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:17:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:49508 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbXHNORC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f1tKEZz+p25F07t6s0MiL54r788O+Lm4jTyMaM1qcCwwUNb4S7I0LTzo6AwQSclKDrX00lkiGauc2z6XGaWfG654+/tfBPNKfR47mzyWR/4C9e+hAHmm+yG8DwBfExeBri8FTPUr1LeYMZrYnKyto95VJo+4mpKMilQWQ5RKo6Y=
Message-ID: <3ae72650708140717y73697cd6ua126440e44a7ad20@mail.gmail.com>
Date: Tue, 14 Aug 2007 16:17:01 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] Firmware class name collision
Cc: "Markus Rechberger" <markus.rechberger@amd.com>,
       "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20070814153340.4f844f5a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C05896.4050509@amd.com> <1187025047.6698.219.camel@violet>
	 <46C092EB.1070501@amd.com> <20070814153340.4f844f5a@hyperion.delvare>
X-Google-Sender-Auth: 40bcc0e965ca6738
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/07, Jean Delvare <khali@linux-fr.org> wrote:
> On Mon, 13 Aug 2007 19:20:43 +0200, Markus Rechberger wrote:
> > Marcel Holtmann wrote:
> > > I would prefer if we use "firmware-%s" since the "fw" might collide with
> > > the new Firewire stack. Please change that and I agree.
> >
> > firmware-%s sounds more informative and cannot be mistaken with firewire
> > yes.
> >
> > Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
> >
> > http://mcentral.de/~mrec/patches/firmware_class_name_collision_2.diff
> >
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index b24efd4..bfc54a1 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -297,8 +297,7 @@ firmware_class_timeout(u_long data)
> >
> >  static inline void fw_setup_device_id(struct device *f_dev, struct
> > device *dev)
> >  {
> > -       /* XXX warning we should watch out for name collisions */
> > -       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
> > +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s", dev->bus_id);
> >  }
>
> Please keep in mind that BUS_ID_SIZE is "only" 20. "firmware-" takes 9
> characters, add one for the trailing zero and this only leaves room for
> 10 characters for the original bus id. While this will be enough for
> the i2c case, I suspect that some other bus IDs won't fit.

Hmm, is there any case where .bus_id is different from .kobj.k_name?
We always do:
  kobject_set_name(&dev->kobj, "%s", dev->bus_id);

Which looks kind of weird, as the kobject (which doesn't have that
name size limitation) is always embedded in the same struct anyway.

Thanks,
Kay
