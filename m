Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYIBF0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYIBF0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYIBF0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:26:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:33596 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYIBF0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:26:37 -0400
Date: Tue, 2 Sep 2008 14:26:16 +0900
To: rct@gherkin.frus.com, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.27-rc5: kobject: tried to init an initialized
 object...
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080902051704.GA2261@gherkin.frus.com>
References: <20080902051704.GA2261@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080902142515R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 00:17:05 -0500
Bob Tracy <rct@gherkin.frus.com> wrote:

> I'm getting the following when I boot 2.6.27-rc5.  Completely reproducible.
> Kernel is stock -rc5 except for Krzysztof Helt's AMD K6 mtrr patch.
> ("cat /proc/mtrr" no longer generates an I/O error, but there's no output
> either).  If more context is needed, I can forward a complete "dmesg" log.
> 
> (...)
> Floppy drive(s): fd0 is 1.2M, fd1 is 1.44M
> FDC 0 is a post-1991 82077
> kobject (d7991e44): tried to init an initialized object, something is seriously wrong.
> Pid: 1, comm: swapper Not tainted 2.6.27-rc5 #1
>  [<c01f547f>] kobject_init+0x2b/0x55
>  [<c01f586c>] kobject_init_and_add+0x10/0x2c
>  [<c01e9483>] elv_register_queue+0x52/0x58
>  [<c01efa03>] blk_register_filter+0x39/0x44
>  [<c01ee8e2>] add_disk+0x3a/0x85
>  [<c01ee294>] exact_match+0x0/0x7
>  [<c01ee684>] exact_lock+0x0/0xd
>  [<c03f6d34>] floppy_init+0x7d2/0xa59
>  [<c010103a>] _stext+0x3a/0x12a
>  [<c03f6562>] floppy_init+0x0/0xa59
>  [<c018a44c>] create_proc_entry+0x69/0x7b
>  [<c013ecfe>] register_irq_proc+0x74/0x8c
>  [<c03e6669>] kernel_init+0x5e/0xa9
>  [<c03e660b>] kernel_init+0x0/0xa9
>  [<c0102f77>] kernel_thread_helper+0x7/0x10
>  =======================
> natsemi dp8381x driver, version 2.1, Sept 11, 2006
>   originally by Donald Becker <becker@scyld.com>
>   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
> PCI: setting IRQ 12 as level-triggered

Sorry about that. A fix was queued in Jens' tree:

http://marc.info/?l=linux-kernel&m=122000748432301&w=2


Jens, can you send the fix to Linus shortly?
