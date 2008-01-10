Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYAJMgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYAJMgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYAJMg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:36:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57316 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYAJMg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:36:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <478610E8.4060602@s5r6.in-berlin.de>
Date: Thu, 10 Jan 2008 13:34:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Greg KH <gregkh@suse.de>, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org,
       cbou@mail.ru, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, rtc-linux@googlegroups.com,
       spi-devel-general@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
References: <478227D5.8050402@s5r6.in-berlin.de> <20080107154404.GA10880@suse.de> <47825DC1.3090102@s5r6.in-berlin.de> <20080107172009.GA25943@suse.de> <a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com> <20080108224837.GA19623@suse.de> <a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com> <20080109061316.GA3249@darkstar.te-china.tietoenator.com> <a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com> <a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com> <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> This is the first one of the series about driver core changes.

Please always provide kerneldoc comments when you add new API elements;
here: exported functions.

It's unfortunate that the driver core's API isn't fully documented yet,
and you shouldn't make it worse.

That's only my personal opinion as one API user though.  But others
might agree.  Among else, things worth documenting are return values
after errors, side effects (!), constraints on the calling context if
there are any special constraints.

I assume you didn't write documentation yet because you need general
feedback first.

...
> +struct device *class_find_device(struct class *class, void *data,
> +				   int (*match)(struct device *, void *))
> +{
> +	struct device *dev;
> +
> +	if (!class)
> +		return NULL;
> +
> +	mutex_lock(&class->mutex);
> +	list_for_each_entry(dev, &class->devices, node)
> +		if (match(dev, data) && get_device(dev))
> +			break;
> +	mutex_unlock(&class->mutex);
> +
> +	return dev;
> +}

What is returned if there was no match?
What if there was a match but get_ failed?

...
> +struct class_device *class_find_child(struct class *class, void *data,
> +				   int (*match)(struct class_device *, void *))
> +{
...
> +	mutex_lock(&class->mutex);
> +	list_for_each_entry(dev, &class->children, node)
> +		if (match(dev, data) && class_device_get(dev))
> +			break;
> +	mutex_unlock(&class->mutex);
> +
> +	return dev;
> +}

Here too?
-- 
Stefan Richter
-=====-==--- ---= -=-=-
http://arcgraph.de/sr/
