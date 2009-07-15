Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbZGOGkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbZGOGkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZGOGkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:40:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:49760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZGOGkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:40:23 -0400
Subject: drivers/isdn/hardware/mISDN/hfcpci.c compiler warning seems like a
 BUG
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Matthias Urlichs <matthias@urlichs.de>, Karsten Keil <kkeil@suse.de>,
       isdn@linux-pingi.de, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 12:09:57 +0530
Message-Id: <1247639997.2437.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this compiler warning in linus tree :

  CC [M]  drivers/isdn/hardware/mISDN/hfcpci.o
drivers/isdn/hardware/mISDN/hfcpci.c: In function ‘hfcpci_softirq’:
drivers/isdn/hardware/mISDN/hfcpci.c:2333: warning: ignoring return value of ‘driver_for_each_device’, declared with attribute warn_unused_result

static void
hfcpci_softirq(void *arg)
{
        (void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
                                        _hfcpci_softirq);

        /* if next event would be in the past ... */
        if ((s32)(hfc_jiffies + tics - jiffies) <= 0)
                hfc_jiffies = jiffies + 1;
        else
                hfc_jiffies += tics;
        hfc_tl.expires = hfc_jiffies;
        add_timer(&hfc_tl);
}

It seems to me it should return is driver_for_each_device fails :
        if (driver_for_each_device(&hfc_driver.driver, NULL, arg,
                                   _hfcpci_softirq))
		return;

or if possible can we return this error code for hfcpci_softirq()

Thanks,
--
JSR


