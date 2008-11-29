Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYK2UVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYK2UVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 15:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYK2UUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 15:20:50 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:41297 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751691AbYK2UUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 15:20:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4lT4slGFKzn1XZ9WRpoYKe4iEdXNmnTPnstfoVHVGn9Z1nNqNq/BrUe8N55lrJeLHgg+P2mRamNKvjsZfzaIgndzqD1QEt5aeXqsFx9yBmbHw/fYkWmeZF0DCekUInV0YUCvYR06I9uMEIgzTypb9pi3NJeYzQoo/8bTmKaXK+o=  ;
X-YMail-OSG: w0Os82wVM1npRcN5xSe9GQW9XUDiu4prIR_DMZ22pNc9J_LzR7Zhr7IVluOnVNDdkPrTj0AlAtL0NJOQ5iaSH9I1k7FkQiw67a.i.bjx2SayvvrHba_JdXGleo4HIpj54a0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] v4l2_device/v4l2_subdev: final (?) version
Date: Sat, 29 Nov 2008 12:20:47 -0800
User-Agent: KMail/1.9.10
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org,
       Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200811291852.41794.hverkuil@xs4all.nl>
In-Reply-To: <200811291852.41794.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811291220.47542.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008, Hans Verkuil wrote:
> +void v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
> +{
> +       BUG_ON(!dev || !v4l2_dev || dev_get_drvdata(dev));
> 

Ouch.  Better to return -EINVAL, like most register() calls,
than *ever* use a BUG_ON() for bad parameters.  Same applies
every other place you use BUG_ON, from a quick scan ...

For the unregister() paths a WARN() would be fair.  Again,
any time you're tempted to use BUG() or BUG_ON(), you need
to re-think.  It's hardly ever the right thing to do.  Just
report the error and continue; callers should check, and
clean up if something went wrong.


> +EXPORT_SYMBOL(v4l2_device_register);

This may be a nit, but I wonder why not EXPORT_SYMBOL_GPL,
which seems to be more correct in this case.


Another quasi-style point:  v4l2-device.s and v4l-subdev.c
are so small, and conceptually related, that I'd be tempted
to have one file not two.  Ditto their headers.

- Dave

