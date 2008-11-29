Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYK2Vqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYK2Vqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYK2Vqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:46:43 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3012 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYK2Vqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:46:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] v4l2_device/v4l2_subdev: final (?) version
Date: Sat, 29 Nov 2008 22:46:20 +0100
User-Agent: KMail/1.9.9
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org,
       Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200811291852.41794.hverkuil@xs4all.nl> <200811291220.47542.david-b@pacbell.net>
In-Reply-To: <200811291220.47542.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811292246.20338.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008 21:20:47 David Brownell wrote:
> On Saturday 29 November 2008, Hans Verkuil wrote:
> > +void v4l2_device_register(struct device *dev, struct v4l2_device
> > *v4l2_dev) +{
> > +       BUG_ON(!dev || !v4l2_dev || dev_get_drvdata(dev));
>
> Ouch.  Better to return -EINVAL, like most register() calls,
> than *ever* use a BUG_ON() for bad parameters.  Same applies
> every other place you use BUG_ON, from a quick scan ...

Are there some documented guidelines on when to use BUG_ON? I see it 
used in other places in this way. My reasoning was that returning an 
error makes sense if external causes can result in an error, but this 
test is more the equivalent of an assert(), i.e. catching a programming 
bug early.

> For the unregister() paths a WARN() would be fair.  Again,
> any time you're tempted to use BUG() or BUG_ON(), you need
> to re-think.  It's hardly ever the right thing to do.  Just
> report the error and continue; callers should check, and
> clean up if something went wrong.
>
> > +EXPORT_SYMBOL(v4l2_device_register);
>
> This may be a nit, but I wonder why not EXPORT_SYMBOL_GPL,
> which seems to be more correct in this case.

I was under the impression that the v4l core was all EXPORT_SYMBOL, but 
I took another look and a lot is now EXPORT_SYMBOL_GPL, so I guess I 
should use that as well.

> Another quasi-style point:  v4l2-device.s and v4l-subdev.c
> are so small, and conceptually related, that I'd be tempted
> to have one file not two.  Ditto their headers.

They are small now, but they will become a lot larger in the future. 
There is a lot of common code in most if not all of the v4l drivers and 
my intention is to gradually expand the framework and move some of the 
common code into these headers/sources. This is just the start.

>
> - Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
