Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZIGJ4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZIGJ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZIGJ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:56:12 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:39377 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbZIGJ4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:56:12 -0400
Message-ID: <4AA4D8BA.602@parrot.com>
Date: Mon, 7 Sep 2009 11:56:10 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: "sdhci-devel@lists.ossman.eu" <sdhci-devel@lists.ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sdhci can turn off irq up to 200 ms
References: <4A4B6184.7000903@parrot.com>	<4A55C631.7030103@parrot.com> <20090906152537.15303d69@mjolnir.ossman.eu>
In-Reply-To: <20090906152537.15303d69@mjolnir.ossman.eu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman a écrit :
> On Thu, 9 Jul 2009 12:28:01 +0200
> Matthieu CASTET <matthieu.castet@parrot.com> wrote:
> 
>> Matthieu CASTET a écrit :
>>> Hi,
>>>
>>> sdhci code got tasklets (sdhci_tasklet_card and sdhci_tasklet_finish),
>>> that does :
>>> {
>>> spin_lock_irqsave
>>>
>>> if (cond) {
>>> sdhci_reset
>>> sdhci_reset
>>> }
>>>
>>> spin_unlock_irqrestore
>>> }
>>>
>>> The problem is that sdhci_reset [1] does busy pooling on a register up
>>> to a timeout of 100 ms.
>>> That's not low latency friendly.
>>>
>>> On our system, we saw that sdhci_reset take 1 ms. That should be because
>>> we enter in mdelay, even if the hardware clears the bit faster.
>>> I wonder why there is an mdelay(1). Using cpu_relax and
>>> time_is_after_jiffies should make sdhci_reset faster.
>>>
>> In case somebody cares, here a patch that reduce on our hardware
>> sdhci_reset from 1 ms to 30 us.
>>
> 
> I seem to recall having problems with jiffies not updating with those
> locks held (or perhaps it was when inside the isr).
> 
> What arch have you been testing this on?
It have been tested on arm.

Matthieu
