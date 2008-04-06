Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYDFWWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYDFWWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 18:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYDFWV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 18:21:57 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:60763 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbYDFWV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 18:21:56 -0400
Date: Sun, 6 Apr 2008 18:18:17 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: kernel <kernel@avr32linux.org>, slipszi@gmail.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG, bisected] atmel_spi: hard lockups in transfer
Message-ID: <20080406181817.5824f962@siona.local>
In-Reply-To: <1207438118.3319.8.camel@moss.renham>
References: <1207438118.3319.8.camel@moss.renham>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2008 22:19:24.0603 (UTC) FILETIME=[452800B0:01C89834]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Apr 2008 09:28:38 +1000
Ben Nizette <bn@niasdigital.com> wrote:

> Hi,
> 
> For some weeks now there have been reports flying across the main AVR32
> support forum, avrfreaks [1], that atmel_spi now hard-hangs on most
> transfers.  The behaviour is not apparent in .23 and is in .24+.  One
> tester was good enough to bisect the problem and turned up

Thanks for reporting this.

> 154443c72f47169ebcb3a7befbff0e934c49bff3
> atmel_spi: chain DMA transfers
> 
> as the culprit.  The tester also had to revert 
> 
> commit 8bacb219018a52e6f02a3cff6a7badf102ddfc44
> atmel_spi: fix dmachain oops with DEBUG enabled
> 
> when they reverted 154443 as they were not confident enough to resolve
> the conflicts that resulted from just reverting the first one.

That is indeed the correct way to resolve the conflict since the latter
fixes a bug introduced by the former.

> The discussion thread involving this can be seen at [2].
> 
> As I say, this is present in .24+ so any fix will be a stable candidate
> as well as .25 material (if we haven't missed the boat by then).

I'm afraid I don't have much time to look at this right now...but I'll
see what I can do. It's strange that I never noticed this problem
myself -- I did see some overrun issues, but I blamed it on the
throughput improvements and just reduced the speed slightly.

Do you have any special debugging options enabled?

Haavard
