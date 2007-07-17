Return-Path: <linux-kernel-owner+w=401wt.eu-S936958AbXGQXZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936958AbXGQXZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763933AbXGQXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:24:54 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40929 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762378AbXGQXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:24:54 -0400
Date: Wed, 18 Jul 2007 01:24:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: a52b1752c07 broke !SMP: error: implicit declaration of function
	`WARN_ON'
Message-ID: <20070717232446.GA20140@lala>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

kernel/timer.c (and some others as arch/arm/kernel/irq.c) include
<linux/smp.h>, but not <linux/kernel.h>

a52b1752c07 introduces usage of the WARN_ON macro in <linux/smp.h>, but
doesn't pull in <linux/kernel.h>.  (<asm/bug.h> is not enough, at least
for arm, because WARN_ON uses printk there.)

The obvious options are:

1) include <linux/kernel.h> in <linux/smp.h>, maybe conditioned by !SMP
2) include <linux/kernel.h> in all includers of <linux/smp.h>
3) remove the WARN_ONs introduced by a52b1752c07.

WARN_ON is used in an inline function that isn't used in every file
including <linux/smp.h>, so maybe updating the compiler might make
the effort for 2) smaller!?  (I'm using gcc 3.4.4)

Best regards
Uwe

-- 
Uwe Kleine-König

$ dc -e "5735816763073014741799356604682P"
