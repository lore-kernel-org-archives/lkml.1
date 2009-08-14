Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZHNST5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZHNST5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZHNST5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:19:57 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33768 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753249AbZHNST4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:19:56 -0400
Message-ID: <4A85AAC4.7050505@acm.org>
Date: Fri, 14 Aug 2009 12:19:48 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
References: <20090814170228.GM13320@pengutronix.de>
In-Reply-To: <20090814170228.GM13320@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090814/1Mc1NU-0001P9-SH-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:

> - 2.4 s up from u-boot to the end of "Uncompressing Linux"
> - 300 ms until ubifs initialization starts
> - 3.7 s for ubifs, until "mounted root"
> 
> So we basically have 7 s for the kernel. The rest is userspace, which hasn't
> seen much optimization yet, other than trying to start the GUI application as
> early as possible, while doing all other init stuff in parallel. Adding "quiet"
> brings us another 300 ms.
> 
> That's factor 70 away from the 110 ms boot time Tim has talked about some days
> ago (and he measured on an ARM cpu which had almost half the speed of this
> one), and I'm wondering what we can do to improve the boot time.

2.4s in uncompression? That seems like an obvious target for improvement.

Your kernel seems awfully large. 3104K code? You should definitely find 
out what is making it that big and cut out everything you do not need. 
You might even try some of the embedded system scripts that rip out all 
the printk strings.

If you get the kernel size way down then use a uncompressed kernel and 
it should boot a lot faster if the bottleneck is CPU speed.

However, it is probably IO speed. There could be something really wrong 
and slow with your MTD. Does it DMA or is it doing something crazy like 
using the CPU to read a byte at a time?

Or maybe its cheap and slow flash. In that case I think your only hope 
is to make all the code as small as possible and/or find a different 
flash filesystem that does not have to read so much of the device to 
mount. Perhaps use a read-only compressed filesystem for the system 
binaries and reflash it for software upgrades. Only init and mount the 
writable flash for user-storable data well after system boot has finished.
-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
