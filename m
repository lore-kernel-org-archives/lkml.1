Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbXLENM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbXLENM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 08:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXLENMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 08:12:18 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:53457 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbXLENMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 08:12:17 -0500
Date: Wed, 5 Dec 2007 18:41:40 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, sfr@canb.auug.org.au
Subject: Re: 2.6.24-rc4-mm1: kobj changes fallout on powerpc
Message-ID: <20071205131140.GA13189@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205091515.GA19962@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205091515.GA19962@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 03:15:15AM -0600, Olof Johansson wrote:
> powerpc allyesconfig fails on the following two drivers (iseries_defconfig
> fails for the veth one):
> 
> drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
> drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has no member named 'kobj'
> drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has no member named 'kobj'
> drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has no member named 'kobj'
> drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
> drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has no member named 'kobj'
> drivers/net/iseries_veth.c: In function 'veth_module_init':
> drivers/net/iseries_veth.c:1714: error: 'struct device_driver' has no member named 'kobj'
> 
> I'm guessing it's some of Greg's kobj/driver patches that missed to
> change this, but it's not obvious to me how it should be fixed.
> 
> 
> -Olof
Hi,

Probably this patch should fix the build failure (The kobject related
structure have been moved to driver_private struct).

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc4/drivers/net/ehea/ehea_main.c	2007-12-04 09:56:10.000000000 +0530
+++ linux-2.6.24-rc4/drivers/net/ehea/~ehea_main.c	2007-12-05 18:01:31.000000000 +0530
@@ -2809,7 +2809,7 @@ static int ehea_driver_sysfs_add(struct 
 {
 	int ret;
 
-	ret = sysfs_create_link(&driver->kobj, &dev->kobj,
+	ret = sysfs_create_link(&driver->driver_private->kobj, &dev->kobj,
 				kobject_name(&dev->kobj));
 	if (ret == 0) {
 		ret = sysfs_create_link(&dev->kobj, &driver->kobj,
