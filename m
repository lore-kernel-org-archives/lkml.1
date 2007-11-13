Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbXKMHJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbXKMHJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXKMHJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:09:05 -0500
Received: from [212.12.190.48] ([212.12.190.48]:39998 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751221AbXKMHJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:09:04 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: top lies ?
Date: Tue, 13 Nov 2007 10:08:56 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200711131008.56627.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kloczek wrote:
> Some data showed by top command looks like completly trashed.
> Fragment from top output:
>
> Mem:   2075784k total,  2053352k used,    22432k free,    19260k buffers
> Swap:  2096472k total,      136k used,  2096336k free,  1335080k cached
>
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP nFLT
> WCHAN     COMMAND 14515 mysql     20   0 1837m 563m 4132 S   39 27.8 
> 27:14.20 1.2g   18 -         mysqld
>
> How it is possible that swap ussage is 136k and swapped out portion of (in
> this case) mysqld process is 1.2g ?

Welcome to OverCommit, aka OOM-nirvana.

Try this:
# echo 2 > /proc/sys/vm/overcommit_memory
# echo 0 > /proc/sys/vm/overcommit_ratio

But make sure you have enough swap.


Thanks!

--
Al

