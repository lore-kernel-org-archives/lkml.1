Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXLEJLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXLEJLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXLEJLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:11:09 -0500
Received: from lixom.net ([66.141.50.11]:57496 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXLEJLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:11:07 -0500
Date: Wed, 5 Dec 2007 03:15:15 -0600
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, sfr@canb.auug.org.au
Subject: 2.6.24-rc4-mm1: kobj changes fallout on powerpc
Message-ID: <20071205091515.GA19962@lixom.net>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc allyesconfig fails on the following two drivers (iseries_defconfig
fails for the veth one):

drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has no member named 'kobj'
drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has no member named 'kobj'
drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has no member named 'kobj'
drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has no member named 'kobj'
drivers/net/iseries_veth.c: In function 'veth_module_init':
drivers/net/iseries_veth.c:1714: error: 'struct device_driver' has no member named 'kobj'

I'm guessing it's some of Greg's kobj/driver patches that missed to
change this, but it's not obvious to me how it should be fixed.


-Olof
