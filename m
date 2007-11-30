Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbXK3Aaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbXK3Aaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbXK3AaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:30:25 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:48131 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763053AbXK3AaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:30:24 -0500
To: Paul Rolland <rol@witbe.net> (Witbe.net)
Subject: Re: constant_tsc and TSC unstable
Cc: linux-kernel@vger.kernel.org, rol@witbe.net
In-reply-To: <20071129171142.56c7890a@tux.DEF.witbe.net>
References: <20071129171142.56c7890a@tux.DEF.witbe.net>
Message-Id: <E1Ixtlu-0003UO-0n@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 30 Nov 2007 01:30:22 +0100
X-OriginalArrivalTime: 30 Nov 2007 00:30:22.0320 (UTC) FILETIME=[316EB700:01C832E8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Total of 2 processors activated (6919.15 BogoMIPS).
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> checking TSC synchronization [CPU#0 -> CPU#1]:
> Measured 3978592228 cycles TSC warp between CPUs, turning off TSC clock.
> Marking TSC unstable due to: check_tsc_sync_source failed.
> Brought up 2 CPUs
> ...

Not sure if this is related, but thought I'd contribute it anyway...

I've got a Pentium D system (dual core, single processor) and I on some
boots I get "Marking TSC unstable due to check_tsc_sync_source failed" with
some cycles warp between CPUs, while most boots are OK. This kind of
inconsistency seems more due to a failure in the kernel to deal with
differences between boots than with something inherent to the hardware.

I conclude that because basically I never have any problems with the system
once it has booted and the TSC has passed.

>From my kern.logs since Okt 26, I get the following data:
2.6.23+cfs:  2 passes
2.6.23.1:    1 pass;   1 failure  (48 cycles warp)
2.6.24-rc1: 15 passes
2.6.24-rc2: 13 passes; 1 failure  (8 cycles warp)
2.6.24-rc3:  5 passes; 3 failures (8, 8 and 16 cycles warp)

Note that this is not a new issue. For 2.6.21/2.6.23-RCx kernels I reported
similar data in http://lkml.org/lkml/2007/9/16/45.

Cheers,
FJP
