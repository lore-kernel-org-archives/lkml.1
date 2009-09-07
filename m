Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZIGQVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZIGQVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZIGQVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:21:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49396 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZIGQVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:21:12 -0400
Date: Mon, 7 Sep 2009 18:20:29 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RT + staging] buildfailures
Message-ID: <20090907162029.GA855@pengutronix.de>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com> <20090614230044.GA21624@pengutronix.de> <20090622151515.GA16627@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090622151515.GA16627@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just tried to compile 2.6.31-rc8-rt9 on amd64 and got the following
compiler errors in drivers/staging:

 - drivers/staging/comedi:

	  CC [M]  drivers/staging/comedi/drivers/quatech_daqp_cs.o
	drivers/staging/comedi/drivers/quatech_daqp_cs.c: In function ‘daqp_interrupt’:
	drivers/staging/comedi/drivers/quatech_daqp_cs.c:308: error: implicit declaration of function ‘up’
	drivers/staging/comedi/drivers/quatech_daqp_cs.c: In function ‘daqp_ai_insn_read’:
	drivers/staging/comedi/drivers/quatech_daqp_cs.c:421: error: implicit declaration of function ‘sema_init’
	drivers/staging/comedi/drivers/quatech_daqp_cs.c:434: error: implicit declaration of function ‘down_interruptible’

   Possible fix: #include <linux/semaphore.h> in
   drivers/staging/comedi/comedidev.h

 - drivers/staging/rt2870:
	  CC [M]  drivers/staging/rt2870/common/2870_rtmp_init.o
	drivers/staging/rt2870/common/2870_rtmp_init.c: In function ‘CreateThreads’:
	drivers/staging/rt2870/common/2870_rtmp_init.c:754: error: implicit declaration of function ‘semaphore_init_locked’

   with PREEMPT_RT semaphore_init_locked doesn't exist.  The driver
   needs to be converted to use mutexes instead.

   Hhhhm, tglx introduced these in

	041e313 (staging: Bulk convert the semaphore mess)

   !?

   drivers/staging/rt3070/common/2870_rtmp_init.c includes
   ../../rt2870/common/2870_rtmp_init.c, so RT3070 has the same problem.

Just to let you know ...

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
