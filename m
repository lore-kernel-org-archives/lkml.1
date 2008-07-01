Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYGAL4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYGAL4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYGAL4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:56:39 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60326 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbYGAL4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:56:38 -0400
Date: Tue, 1 Jul 2008 14:56:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dmitry Torokhov <dtor@mail.ru>, geert@linux-m68k.org,
       zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: m68k input/ff-core.c build error
Message-ID: <20080701115619.GB17558@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 656acd2bbc4ce7f224de499ee255698701396c48
(Input: fix locking in force-feedback core)
causes the following build error on m68k:

<--  snip  -->

...
  CC      drivers/input/ff-core.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/ff-core.c: In function 'input_ff_upload':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/ff-core.c:172: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/ff-core.c: In function 'erase_effect':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/ff-core.c:197: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/ff-core.c:204: error: dereferencing pointer to incomplete type
make[3]: *** [drivers/input/ff-core.o] Error 1

<--  snip  -->

Not sure what exactly the problem is, the failures are the
added spin_unlock_irq(&dev->event_lock)'s.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

