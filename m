Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0CIJ3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:29:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58551
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854Ab0CIJ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:29:17 -0500
Date: Tue, 09 Mar 2010 01:29:35 -0800 (PST)
Message-Id: <20100309.012935.98310472.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: mkl0301@gmail.com, thomas@koeller.dyndns.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: DMA using data buffer vmapped in kernel space
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100309091403.GB5691@n2100.arm.linux.org.uk>
References: <20100306193127.GA13262@n2100.arm.linux.org.uk>
	<10d816431003082345j5438d8cdi8ad72c4fa296b684@mail.gmail.com>
	<20100309091403.GB5691@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Tue, 9 Mar 2010 09:14:03 +0000

> What you could do is prepare a patch to allow the firmware support to
> export a scatterlist via the struct firmware, and then use that with
> dma_map_sg().  Let's hope that the SPI interfaces support scatterlists.

It's so common to want a scatterlist from a vmalloc/vmap area
that a generic common helper is probably the best.

Just iterate over the vmalloc/vmap area using vmalloc_to_page()
to fill in the SG entries.
