Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbXLMQYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbXLMQYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbXLMQYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:24:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46978 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbXLMQYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:24:22 -0500
Date: Thu, 13 Dec 2007 08:21:23 -0800
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc5-mm1 - build failures due to kobject changes
Message-ID: <20071213162123.GA7580@kroah.com>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <47614CB2.40803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47614CB2.40803@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:46:02PM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel build fails, due to kobjects changes
> 
> drivers/infiniband/hw/ehca/ehca_main.c: In function ???ehca_module_init???:
> drivers/infiniband/hw/ehca/ehca_main.c:947: error: ???struct device_driver??? has no member named ???kobj???
> drivers/infiniband/hw/ehca/ehca_main.c: In function ???ehca_module_exit???:
> drivers/infiniband/hw/ehca/ehca_main.c:976: error: ???struct device_driver??? has no member named ???kobj???
> make[3]: *** [drivers/infiniband/hw/ehca/ehca_main.o] Error 1
> make[2]: *** [drivers/infiniband/hw/ehca] Error 2
> make[1]: *** [drivers/infiniband] Error 2
> make: *** [drivers] Error 2

This is a simple fix to the new api, sorry, being ppc I missed it in my
build tests.

> drivers/net/ehea/ehea_main.c: In function ???ehea_driver_sysfs_add???:
> drivers/net/ehea/ehea_main.c:2812: error: ???struct device_driver??? has no member named ???kobj???
> drivers/net/ehea/ehea_main.c:2815: error: ???struct device_driver??? has no member named ???kobj???
> drivers/net/ehea/ehea_main.c:2818: error: ???struct device_driver??? has no member named ???kobj???
> drivers/net/ehea/ehea_main.c: In function ???ehea_driver_sysfs_remove???:
> drivers/net/ehea/ehea_main.c:2830: error: ???struct device_driver??? has no member named ???kobj???
> make[3]: *** [drivers/net/ehea/ehea_main.o] Error 1
> make[2]: *** [drivers/net/ehea] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

That's just broken and wrong.  Why are you trying to duplicate a symlink
that the driver core already creates?  I'll just delete this code,
ugh...

>   CC      drivers/net/iseries_veth.o
> drivers/net/iseries_veth.c: In function ???veth_module_init???:
> drivers/net/iseries_veth.c:1714: error: ???struct device_driver??? has no member named ???kobj???
> make[2]: *** [drivers/net/iseries_veth.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

This one I know about and have more work to do to fix properly.

thanks,

greg 'i need to install a ppc cross-compiler one of these days' k-h
