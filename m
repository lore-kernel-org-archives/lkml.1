Return-Path: <linux-kernel-owner+w=401wt.eu-S1161556AbXDLDwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161556AbXDLDwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 23:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422627AbXDLDwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 23:52:04 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37007 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161556AbXDLDwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 23:52:03 -0400
Date: Wed, 11 Apr 2007 20:43:23 -0700
From: Greg KH <greg@kroah.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412034323.GA7017@kroah.com>
References: <20070411232503.GC20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411232503.GC20095@zarina>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:25:03AM +0400, Anton Vorontsov wrote:
> Here is battery monitor class. According to first copyright string, we're
> maintaining it since 2003. I've took few days and cleaned it up to be
> more suitable for mainline inclusion.
> 
> It differs from battery class at git://git.infradead.org/battery-2.6.git:

Why fork from David's work?  Does he not like these changes for some
reason?

> +static int battery_create_attrs(struct battery *bat)
> +{
> +	int rc;
> +
> +	#define create_bat_attr_conditional(name)                    \
> +	if(bat->get_##name) {                                        \
> +		rc = device_create_file(bat->dev, &dev_attr_##name); \
> +		if (rc) goto name##_failed;                          \
> +	}
> +
> +	create_bat_attr_conditional(status);
> +	create_bat_attr_conditional(min_voltage);
> +	create_bat_attr_conditional(min_current);
> +	create_bat_attr_conditional(min_capacity);
> +	create_bat_attr_conditional(max_voltage);
> +	create_bat_attr_conditional(max_current);
> +	create_bat_attr_conditional(max_capacity);
> +	create_bat_attr_conditional(temp);
> +	create_bat_attr_conditional(voltage);
> +	create_bat_attr_conditional(current);
> +	create_bat_attr_conditional(capacity);

Use an attribute group please.  It's much simpler and will be created at
the proper time so your userspace tools don't have to sit and spin in
order to properly wait for them to show up.

Ok, yes, you want a conditional type of attribute group, like the
new firewire code does.  I have no problem adding that if you like.

thanks,

greg k-h
