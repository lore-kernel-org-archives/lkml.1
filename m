Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbXGDRGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbXGDRGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXGDRGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:06:36 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:33067 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbXGDRGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:06:36 -0400
Date: Wed, 4 Jul 2007 19:07:53 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070704170753.GO10397@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [RFC] disabling RTC irq during release
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Looking at other rtc drivers I noticed that during the release()
method we should disable IRQs as follow:

static void ds1307_release(struct device *dev)
{
        struct ds1307   *ds1307 = dev_get_drvdata(dev);

        if (ds1307->irq >= 0) {
                ds1307->irqen = 0;
                ds1307_update_alarm(ds1307);
        }
}

that's the code I put into my patch for ds1339.

But if I wish using RTC IRQ line to turn also the board ON, not just
to put to sleep it, I should leave the IRQ line on!

I think we should add a configuration option who allows developers to
choose if the RTC IRQ line should be disabled or not during release().

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
