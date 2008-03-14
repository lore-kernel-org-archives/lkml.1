Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbYCNH50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbYCNH50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYCNH5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:57:18 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52077 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYCNH5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:57:17 -0400
Message-ID: <47DA2FD6.3000100@linux.vnet.ibm.com>
Date: Fri, 14 Mar 2008 13:27:10 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: sfr@canb.auug.org.au, kernel list <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: linux-next20080314 build fails with !CONFIG_PM 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next-20080314 tree build fails 

drivers/serial/serial_core.c: In function `uart_add_one_port':
drivers/serial/serial_core.c:2359: error: invalid lvalue in assignment
make[2]: *** [drivers/serial/serial_core.o] Error 1

The config # CONFIG_PM was not set.The code which is causing the 
build failure is 

	device_can_wakeup(tty_dev) = 1;

when the CONFIG_PM is set the macro is preprocessed as

#define device_can_wakeup(dev) \
        ((dev)->power.can_wakeup)

and when not set, it becomes 0 = 1 

#define device_can_wakeup(dev)                  0

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
