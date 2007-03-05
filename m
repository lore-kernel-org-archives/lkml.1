Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbXCEQSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbXCEQSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXCEQSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:18:15 -0500
Received: from rtr.ca ([64.26.128.89]:4786 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbXCEQSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:18:14 -0500
Message-ID: <45EC42C2.4080403@rtr.ca>
Date: Mon, 05 Mar 2007 11:18:10 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: sdhci-devel@list.drzeus.cx, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45EB9E72.6040107@rtr.ca> <45EBAC73.7010600@drzeus.cx> <45EC2851.7020905@rtr.ca> <45EC352C.4070508@drzeus.cx> <45EC3609.4030809@drzeus.cx> <45EC38C5.1060600@rtr.ca> <45EC3E8C.6000102@drzeus.cx>
In-Reply-To: <45EC3E8C.6000102@drzeus.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Mark Lord wrote:
>
>> From linux/Documentation/power/pci.txt:
>>
> That conveniently leaves out the part of how to handle when we're not
> getting our stuff back. ;)
> 
> But it seems to be the easier route anyway... I'll whip up a patch.

It's probably best all-round.

But another simpler way is to just set a global "am_suspended" bool
in the _suspend() code, and clear it again in the _resume() code,
and check it in the irq handler() code.

And the test for 0xffffffff (my simple patch) is probably good
to have regardless inside the irq handler().

Cheers
