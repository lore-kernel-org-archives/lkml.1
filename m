Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbYFLN1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbYFLN1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbYFLN1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:27:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759098AbYFLN1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:27:24 -0400
Date: Thu, 12 Jun 2008 15:27:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: steiner@sgi.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       holt@sgi.com, andrea@qumranet.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 00/11] GRU Driver
Message-ID: <20080612132700.GA18107@elte.hu>
References: <20080609211028.110089743@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609211028.110089743@attica.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* steiner@sgi.com <steiner@sgi.com> wrote:

> This series of patches adds a driver for the SGI UV GRU. The driver is 
> still in development but it currently compiles for both x86_64 & IA64. 
> All simple regression tests pass on IA64. Although features remain to 
> be added, I'd like to start the process of getting the driver into the 
> kernel. Additional kernel drivers will depend on services provide by 
> the GRU driver.
> 
> The GRU is a hardware resource located in the system chipset. The GRU 
> contains memory that is mmaped into the user address space. This 
> memory is used to communicate with the GRU to perform functions such 
> as load/store, scatter/gather, bcopy, AMOs, etc.  The GRU is directly 
> accessed by user instructions using user virtual addresses. GRU 
> instructions (ex., bcopy) use user virtual addresses for operands.

did i get it right that it's basically a fast, hardware based message 
passing interface that allows two tasks to communicate via DMA and 
interrupts, without holding up the CPU? If that is the case, wouldnt the 
proper support model be a network driver, instead of these special 
ioctls. (a network driver with no checksumming, with scatter-gather, 
zero-copy and TSO support, etc.)

or a filesystem. Anything but special-purpose ioctls ...

	Ingo
