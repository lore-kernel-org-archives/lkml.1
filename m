Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXHVLbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXHVLbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 07:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbXHVLbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 07:31:33 -0400
Received: from [212.12.190.249] ([212.12.190.249]:32833 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752691AbXHVLbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 07:31:32 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: huge improvement with per-device dirty throttling
Date: Wed, 22 Aug 2007 14:31:21 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221431.21297.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey W. Baker wrote:
> I tested 2.6.23-rc2-mm + Peter's per-BDI v9 patches, versus 2.6.20 as
> shipped in Ubuntu 7.04.  I realize there is a large delta between these
> two kernels.
>
> I load the system with du -hs /bigtree, where bigtree has millions of
> files, and dd if=/dev/zero of=bigfile bs=1048576.  I test how long it
> takes to ls /*, how long it takes to launch gnome-terminal, and how long
> it takes to launch firefox.
>
> 2.6.23-rc2-mm-bdi is better than 2.6.20 by a factor between 50x and
> 100x.
:
:
> Yes, you read that correctly.  In the presence of a sustained writer and
> a competing reader, it takes more than 30 minutes to start firefox.
>
> 4.
>
> du -hs /bigtree
>
> Under 2.6.20, lstat64 has a mean latency of 75ms in the presence of a
> sustained writer.  Under 2.6.23-rc2-mm+bdi, the mean latency of lstat64
> is only 5ms (15x improvement).  The worst case latency I observed was
> more than 2.9 seconds for a single lstat64 call.
:
:
> In other words, under 2.6.20, only writing processes make progress.
> Readers never make progress.
>
> 5.
>
> dd writeout speed
>
> 2.6.20: 36.3MB/s, 35.3MB/s, 33.9MB/s
> 2.6.23: 20.9MB/s, 22.2MB/s
>
> 2.6.23 is slower when writing out, because other processes make progress
>
> My system is a Core 2 Duo, 2GB, single SATA disk.

Many thanks for your detailed analysis.

Which io-scheduler did you use, and what numbers do you get with other 
io-schedulers?


Thanks!

--
Al

