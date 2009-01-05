Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZAEN2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZAEN2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZAEN1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:27:43 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34583 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbZAEN1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:27:41 -0500
Date: Mon, 5 Jan 2009 14:29:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: irqnr fallout in gpiolib on sparc32
Message-ID: <20090105132916.GA10545@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hit the following build error on sparc:

drivers/gpio/gpiolib.c: In function `gpiolib_dbg_show':
drivers/gpio/gpiolib.c:1146: error: implicit declaration of function `irq_to_desc'
drivers/gpio/gpiolib.c:1146: warning: initialization makes pointer from integer without a cast


This is with an allmodconfig where I did:

make ARCH=sparc vmlinux

sparc do _not_ have GENERIC_HARDIRQS set to 'y'.

I did a simple:
#include <linux/irqnr.h> but that did not help.

I have not investigated further atm.

It is preproduceable with HEAD equal fe0bdec68b77020281dc814805edfe594ae89e0f
[latest -linus when writing this]

	Sam

