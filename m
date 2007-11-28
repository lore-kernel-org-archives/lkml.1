Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXK1FXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXK1FXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXK1FXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:23:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbXK1FXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:23:10 -0500
Date: Tue, 27 Nov 2007 21:22:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bdupree@techfinesse.com
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
Message-Id: <20071127212217.a7ac0407.akpm@linux-foundation.org>
In-Reply-To: <41877.67.173.156.207.1196130992.squirrel@www.techfinesse.net>
References: <41877.67.173.156.207.1196130992.squirrel@www.techfinesse.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 20:36:32 -0600 (CST) bdupree@techfinesse.com wrote:

> Question: Why is ksoftirqd eating about 5 to 10 percent of my CPU on an idle
> system? The problem occurs if I config the kernel with tickless
> support (i.e. CONFIG_TICK_ONESHOT=y).  (Thanks to "oprofile" for putting me
> onto this.)

beware that oprofile can provide misleading results on a paritally-idle
system.  You may have discovered that ksoftirqd is consuming 5-10% of the
non-idle time on that idle system, which is less surprising.

> I have noted this same problem on kernel versions: 2.6.23.1, 2.6.23.8 and
> 2.6.23.9
> 
> **************************************************************************
> *** Output from "vmstat -n 1 10" -- Note very high context switch rate ***
> *** This is on a idle machine!                                         ***
> **************************************************************************
> 
> procs -----------memory---------- ---swap-- -----io---- --system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
> id wa
>  0  0      0 1925556   4768 116104    0    0   124     2    6  7538  1  2
> 96  1
>  0  0      0 1925556   4768 116104    0    0     0     0    2 147329  0  1
> 99  0
>  0  0      0 1925548   4768 116104    0    0     0     0    0 154515  0  1
> 99  0
>  0  0      0 1925548   4768 116104    0    0     0     0    1 153898  0  2
> 98  0
>  0  0      0 1925548   4780 116104    0    0     0    16    3 155216  0  1
> 99  0
>  0  0      0 1925548   4780 116104    0    0     0     0    1 161718  0  1
> 99  0
>  0  0      0 1925548   4780 116104    0    0     0     0    0 147587  0  2
> 98  0
>  0  0      0 1925548   4780 116104    0    0     0     0    1 153524  0  2
> 98  0
>  0  0      0 1925448   4780 116104    0    0     0     0    0 153434  0  1
> 99  0
>  0  0      0 1925448   4792 116092    0    0     0    16    4 153527  0  2
> 98  0

So what piece of code is scheduling so much?  What does `top' say?  What
does the (sorted) output of oprofile look like?

Did you try shutting down as much userspace code as possible to find out if
some userspace task is misbehaving?

