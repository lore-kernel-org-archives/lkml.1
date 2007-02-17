Return-Path: <linux-kernel-owner+w=401wt.eu-S1946547AbXBQJhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946547AbXBQJhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 04:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946550AbXBQJhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 04:37:20 -0500
Received: from outmx022.isp.belgacom.be ([195.238.4.203]:39966 "EHLO
	outmx022.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946547AbXBQJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 04:37:18 -0500
Message-ID: <45D6CC81.1040004@246tNt.com>
Date: Sat, 17 Feb 2007 10:36:01 +0100
From: Sylvain Munaut <tnt@246tNt.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060615)
MIME-Version: 1.0
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
CC: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com, pmac@au1.ibm.com, fenkes@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Use of_device_uevent()
References: <200702170356.12600.hnguyen@linux.vnet.ibm.com>
In-Reply-To: <200702170356.12600.hnguyen@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hoang-Nam Nguyen wrote:
> This patch replaces ibmebus_uevent() by Sylvain's generic function.
>
>  struct bus_type ibmebus_bus_type = {
> -	.name = "ibmebus",
> -	.uevent = ibmebus_uevent,
> -	.match = ibmebus_bus_match,
> +	.name   = "ibmebus",
> +	.uevent = of_device_uevent,
> +	.match  = ibmebus_bus_match,
>  };
>  EXPORT_SYMBOL(ibmebus_bus_type);
>   
Doesn't that oops when called with the fake parent device ?

Either you do a wrapper that test for it (that's what I did when I
posted the patch).
Or, an even better approach is to add this

+	if (!ebus_dev->ofdev.node)
+		return -ENODEV;

inside the code of of_device_uevent itself.


	Sylvain



