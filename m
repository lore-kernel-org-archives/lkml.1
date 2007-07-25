Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbXGYTGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbXGYTGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXGYTGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:06:09 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:47434 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbXGYTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:06:07 -0400
Message-ID: <46A79F14.9040409@freescale.com>
Date: Wed, 25 Jul 2007 14:05:56 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.7.10) Gecko/20050909 Red Hat/1.7.10-1.1.3.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <46A79DE0.8060405@ru.mvista.com>
In-Reply-To: <46A79DE0.8060405@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>>+	hwif->hw.io_ports[IDE_DATA_OFFSET] = port;
>>+
>>+	port += (1 << pdata->ioport_shift);
>>+	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
>>+	     i++, port += (1 << pdata->ioport_shift))
> 
> 
>     Looks like shift doesn't buy as anything, why not just use stride?

It doesn't buy us anything in here, but it's conceivable that someone 
may want to write a driver that uses a shift in the I/O accessor rather 
than an array of port offsets, and it's easier to convert a shift to a 
stride than the other way around (not all architectures have an 
equivalent of the cntlzw innstruction, and shift makes it clear that the 
stride must be power-of-two).  Plus, using shift is consistent with what 
we do on ns16550.

-Scott
