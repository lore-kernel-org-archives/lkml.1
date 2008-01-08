Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbYAHQaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbYAHQaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYAHQaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:30:18 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42159 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbYAHQaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:30:16 -0500
Date: Tue, 8 Jan 2008 22:03:05 +0530
From: Sudhir Kumar <skumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, greg@kroah.com
Subject: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
Message-ID: <20080108163305.GB10026@in.ibm.com>
Reply-To: skumar@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
Kernel build fails on my machine with error :


  LD      drivers/net/ehea/built-in.o
  CC [M]  drivers/net/ehea/ehea_main.o
drivers/net/ehea/ehea_main.c: In function ‘ehea_driver_sysfs_add’:
drivers/net/ehea/ehea_main.c:2812: error: ‘struct device_driver’ has no
member named ‘kobj’
drivers/net/ehea/ehea_main.c:2815: error: ‘struct device_driver’ has no
member named ‘kobj’
drivers/net/ehea/ehea_main.c:2818: error: ‘struct device_driver’ has no
member named ‘kobj’
drivers/net/ehea/ehea_main.c: In function ‘ehea_driver_sysfs_remove’:
drivers/net/ehea/ehea_main.c:2830: error: ‘struct device_driver’ has no
member named ‘kobj’
make[3]: *** [drivers/net/ehea/ehea_main.o] Error 1
make[2]: *** [drivers/net/ehea] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

The structure device_driver(in device.h) has a member struct driver_private which
contains the member kobj (according to drivers/base/base.h).
But in device.h struct driver_private has been declared localy and 
neither defined nor included from base.h.
So my effort to use driver->driver_private->obj also does not work.
(I am surprised from where do you access the struct device_driver)

Thanks and Regards
Sudhir Kumar
