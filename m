Return-Path: <linux-kernel-owner+w=401wt.eu-S1422792AbXBATMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422792AbXBATMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422947AbXBATMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:12:55 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:33295 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422946AbXBATMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:12:54 -0500
Message-ID: <45C23BAA.5050400@cfl.rr.com>
Date: Thu, 01 Feb 2007 14:12:42 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: TJ <linux@tjworld.net>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by probe
 of partitions
References: <fa.vUjkpPQXmle+uox6D228qG85KCU@ifi.uio.no>  <45C16AA5.7050808@shaw.ca> <1170329269.30563.10.camel@butch.lan.tjworld.net>
In-Reply-To: <1170329269.30563.10.camel@butch.lan.tjworld.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2007 19:13:04.0299 (UTC) FILETIME=[FF8C7FB0:01C74634]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14970.003
X-TM-AS-Result: No--13.333600-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think you may be barking up the wrong tree because IIRC, these 
requests for data beyond the end of the disk never make it to the drive; 
the kernel fails them in the block layer.  There was a patch a while 
back to fix the partition detection code to NOT request sectors beyond 
the end of the disk, but I don't think it was ever merged.

In any case, if you are sure the requests are making it to the drive and 
causing damage, I hope you give Maxtor and IBM a sound thrashing for 
using retarded firmware.

TJ wrote:
> Hi Robert,
> 
> Yes, I'd have expected that too. I'm particularly surprised the
> drive-logic doesn't refuse to move the heads and just report the failure
> based on the LBA value.
> 
> These are Maxtor drives, but its also happened with IBM drives in
> another system with similar configuration, as a test.
> 
> During the bug-hunt (which started end of December) I built about 100
> kernels trying to track down the root cause, and therefore went through
> many reboot cycles.
> 
> Several times the drives were 'knocked out' and would refuse to
> initialise during POST. The only remedy was to leave the system powered
> down for a while - the rest seemed to do them good.
> 
> The difficulty I had in debugging was the errors are generated on the
> work-queue and interrupt handling side, and it was extremely difficult
> to pin-point the root cause because the symptoms (drive seek errors)
> occur well after the partition tables have been scanned, and also repeat
> themselves several times during system start-up.

