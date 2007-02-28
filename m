Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXB1NZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXB1NZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXB1NZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:25:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:1736 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbXB1NZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:25:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C1LicP+6g/dpq72NDMftr979/eMoh6Ed+nFC6gJBu2vrmUCc+mWV6XR1zjB1dNK2G6eSlV4t++OoGztLuJncjPWGDhsUcIOsU1iTJm8urshN/xvn3tTjUDae7aVrJUImB3JiE/HzQFvEIEYhumgkA2XkpW0L1LOJLLljZsX7Rqc=
Message-ID: <40f323d00702280525g3d898a9bm1297dc32b8f7fda2@mail.gmail.com>
Date: Wed, 28 Feb 2007 14:25:07 +0100
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: a bug in AS scheduler?
Cc: "Xiaoning Ding" <dingxn@cse.ohio-state.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070228121040.GW3733@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45E5038F.1090200@cse.ohio-state.edu>
	 <20070228121040.GW3733@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Feb 27 2007, Xiaoning Ding wrote:
> > Hi,
> >
> > I am reading the source code AS scheduler in 2.6.18(as-ioscheduler.c).
> > In function as_close_req, variable delay is in millisecond, while
> > ad->antic_expire is in jiffies. Doesn't the comparison of delay and
> > ad->antic_expire make any problem?
> > The related source code is quoted blow:
> >
> >       if (ad->antic_status == ANTIC_OFF || !ad->ioc_finished)
> >               delay = 0;
> >       else
> >               delay = ((jiffies - ad->antic_start) * 1000) / HZ;
>
> antic_start is in jiffies, the difference is here multiplied by 1000 and
> divided by HZ to turn it into msecs. so delay is in msecs.
>
I am pretty sure Xiaoning was talking about antic_expire, particularly
this comparison:

     else if (delay <= 20 && delay <= ad->antic_expire)

regards,

Benoit
