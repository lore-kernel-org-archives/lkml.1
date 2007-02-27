Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbXB0BPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbXB0BPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXB0BPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:15:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56361 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbXB0BPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:15:04 -0500
Date: Tue, 27 Feb 2007 02:18:03 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] semaphores: add down_interruptible_timeout() and
 asm-generic/semaphore.h
Message-ID: <20070227021803.38c8591f@lxorguk.ukuu.org.uk>
In-Reply-To: <200702261654.18005.inaky@linux.intel.com>
References: <20070227001338.344233745@sodium.jf.intel.com>
	<20070227003313.GA7360@infradead.org>
	<200702261654.18005.inaky@linux.intel.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, I need semaphore. This is a hw register that says when the hw
> is ready to accept a new command. Code that wants to send commands has
> to down the semaphore and then send it. When hw is ready to get a new
> command, it sends and IRQ and the IRQ up()s the semaphore. 

So you need a mutex not a semaphore
> 
> Now, we don't want to hang on that down() forever if the hw spaces out.
> If we get a timeout, we can try recovery actions (like resetting it,
> for sake of being polite). 

Makes sense but you can also do that with mutexes, and its
mutex_interruptible_timeout() you need I suspect ?

Alan
