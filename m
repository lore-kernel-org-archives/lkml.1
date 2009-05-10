Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZEJJy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZEJJy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 05:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZEJJyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 05:54:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:16268 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZEJJyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 05:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hUmh/QEMWKD4blK4jCCiTRwgj2rCv5PGiwphodJyv52UBS/HnRT0d+LhDInAzf26Uy
         TBEdBmHtM81GLOXdqpzdOJ1YhdLSDciBs9BD28Vn8rAPK4bj7ktgr5EQKFqnYZycj1Qy
         ZlsbFMyep8mQUn84tei/tKl7q3sc5SNTc6/FI=
From: Vladimir Zajac <eightgraph@gmail.com>
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2.6.30-rc4] thermal: fix off-by-1 error in trip point trigger condition
Date: Sun, 10 May 2009 11:54:09 +0200
User-Agent: KMail/1.9.9
Cc: Zhang Rui <rui.zhang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <200905061934.21821.eightgraph@gmail.com> <1241657280.15284.107.camel@rzhang-dt>
In-Reply-To: <1241657280.15284.107.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101154.09600.eightgraph@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009 02:48:00 Zhang Rui wrote:
> On Thu, 2009-05-07 at 01:34 +0800, Vladimir Zajac wrote:
> > This patch fixes a regression caused by commit
> > b1569e99c795bf83b4ddf41c4f1c42761ab7f75e
> > "ACPI: move thermal trip handling to generic thermal layer"
> > which accidentally changed trip point trigger condition to
> >   temp > trip_temp
> > 
> > This patch changes the trigger condition back to
> >   temp >= trip_temp
> > 
> > Signed-off-by: Vladimir Zajac <eightgraph@gmail.com>
> 
> Acked-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
> > ---
> > 
> >  thermal_sys.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > --- linux-2.6.30-rc4/drivers/thermal/thermal_sys.c	2009-04-30 23:52:59.000000000 +0200
> > +++ linux-2.6.30-rc4-p1/drivers/thermal/thermal_sys.c	2009-05-04 19:58:30.000000000 +0200
> > @@ -961,7 +961,7 @@ void thermal_zone_device_update(struct t
> >  
> >  		switch (trip_type) {
> >  		case THERMAL_TRIP_CRITICAL:
> > -			if (temp > trip_temp) {
> > +			if (temp >= trip_temp) {
> >  				if (tz->ops->notify)
> >  					ret = tz->ops->notify(tz, count,
> >  							      trip_type);
> > @@ -974,7 +974,7 @@ void thermal_zone_device_update(struct t
> >  			}
> >  			break;
> >  		case THERMAL_TRIP_HOT:
> > -			if (temp > trip_temp)
> > +			if (temp >= trip_temp)
> >  				if (tz->ops->notify)
> >  					tz->ops->notify(tz, count, trip_type);
> >  			break;
> > @@ -986,14 +986,14 @@ void thermal_zone_device_update(struct t
> >  
> >  				cdev = instance->cdev;
> >  
> > -				if (temp > trip_temp)
> > +				if (temp >= trip_temp)
> >  					cdev->ops->set_cur_state(cdev, 1);
> >  				else
> >  					cdev->ops->set_cur_state(cdev, 0);
> >  			}
> >  			break;
> >  		case THERMAL_TRIP_PASSIVE:
> > -			if (temp > trip_temp || tz->passive)
> > +			if (temp >= trip_temp || tz->passive)
> >  				thermal_zone_device_passive(tz, temp,
> >  							    trip_temp, count);
> >  			break;

Forwarding Matthew Garrett's reply from another thread:
> Looks good. You probably need to resend it with a Signed-off-by: line, 
> but feel free to add
> 
> Acked-by: Matthew Garrett <mjg@redhat.com>
> 	
