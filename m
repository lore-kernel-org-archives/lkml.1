Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZGYSDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZGYSDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZGYSDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 14:03:23 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44117 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbZGYSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 14:03:23 -0400
Date: Sat, 25 Jul 2009 20:03:21 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: slqb enables interrupts very early
Message-ID: <20090725180321.GA24814@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've checkout slab-2.6/linux-next and noticed that the interrupts are
enabled very early by accident. Please look at the following call stack:

    start_kernel()
    kmem_cache_init()
    kmem_cache_open()
    down_write(&slqb_lock);
    __down_write()
    __down_write_nested()

Now, __down_write_nested() protects its internal structure the follwing
way:
    spin_lock_irq(&sem->wait_lock);
    ...
    spin_unlock_irq(&sem->wait_lock);

so once we return, we return with interrupts on.

Sebastian
