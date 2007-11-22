Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbXKVRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbXKVRR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 12:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXKVRRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 12:17:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59250 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbXKVRRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 12:17:51 -0500
Date: Thu, 22 Nov 2007 09:17:32 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Use of mutex in interrupt context flawed/impossible, need
 advice.
Message-ID: <20071122091732.02d73217@laptopd505.fenrus.org>
In-Reply-To: <c384c5ea0711220802i21e3df45q1d328aea63e7ebf4@mail.gmail.com>
References: <c384c5ea0711220802i21e3df45q1d328aea63e7ebf4@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 17:02:44 +0100
"Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:

> Hello,
> 
> 
> I'm converting an out-of-tree (*1) driver from binary semaphore to
> mutex.
> 
> Userspace updates a look-up-table using write(). The driver tries to
> write this LUT to the FPGA in the (video frame) interrupt handler. It
> is important that the LUT is consistent and thus changed atomically.
> Note that it is not important that the LUT is updated each interrupt.
> 
> The current approach is to try-down()ing a binary semaphore in
> interrupt context, and write the LUT to the FPGA if the semaphore was
> down()ed, do nothing else.
> The write() down()s the semaphore as well before updating the
> in-driver-copy of the LUT, then up()s it again.
> 
> I understand this design is not clean (*2), and not even possible with
> mutexes, as mutex_trylock() is not interrupt safe.
> 
> My current approach would be to have userspace write into a shadow
> copy, and use a spinlock to update the live copy. The interrupt then
> would try a spinlock.
>

I suspect you need to copy the userspace data anyway, so I don't see
why the spinlock approach would be wrong; if the update itself is short
and non-sleeping, it's even better than a mutex or semaphore.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
