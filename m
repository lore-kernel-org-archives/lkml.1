Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYIITU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYIITU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYIITUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:20:48 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:16942 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200AbYIITUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:20:47 -0400
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression] __tick_program_event of hpet is stuck
Date: Tue, 9 Sep 2008 21:20:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200809080114.36106.elendil@planet.nl> <200809091438.57158.elendil@planet.nl> <alpine.LFD.1.10.0809091503460.3271@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809091503460.3271@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809092120.45295.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2008 19:20:45.0658 (UTC) FILETIME=[289BCBA0:01C912B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008, Thomas Gleixner wrote:
> It's nothing to worry about. I out the WARN_ON() there to get some
> information about the validation of min_delta_ns and to see in which
> range this happens.

Ah, OK. A WARN_ON is perhaps a bit heavy for that, unless you actually
want to be flooded with reports :-)
In my case it prevented me from running the kernel on other boxes than the
laptop because I feared some possibly important issue.

Also, a single line can easily be filtered out from logcheck reports while
doing the same for WARN_ONs is much harder and even not advisable.

> I'm going to remove the WARN_ON() and just keep the information that
> we need to increase the min_delta_ns value for safe operation.

Sounds like a plan; have already done so locally.

Here are some results I've got so far. You can see reboots and supend
to RAMs. Maximum observed value on the HP 2510p is now 80000 with the
system mostly idle or in light use.

Sep  8 00:58:29 aragorn kernel: Linux version 2.6.27-rc5 (root@faramir) ...
Sep  8 00:59:17 aragorn kernel: CE: increasing min_delta_ns 5000 to 10000 nsec
Sep  8 01:56:38 aragorn kernel: CE: increasing min_delta_ns 10000 to 20000 nsec
Sep  8 02:51:23 aragorn kernel: CE: increasing min_delta_ns 20000 to 40000 nsec
Sep  8 05:11:10 aragorn kernel: Back to C!

Sep  9 00:04:16 aragorn kernel: Linux version 2.6.27-rc5 (root@faramir) ...
Sep  9 00:09:04 aragorn kernel: CE: increasing min_delta_ns 5000 to 10000 nsec
Sep  9 14:31:49 aragorn kernel: Back to C!
Sep  9 14:39:41 aragorn kernel: CE: increasing min_delta_ns 10000 to 20000 nsec
Sep  9 14:39:51 aragorn kernel: CE: increasing min_delta_ns 20000 to 40000 nsec

Sep  9 16:59:22 aragorn kernel: Linux version 2.6.27-rc5 (root@faramir) ...
Sep  9 16:59:22 aragorn kernel: CE: increasing min_delta_ns 5000 to 10000 nsec

Sep  9 17:02:18 aragorn kernel: Linux version 2.6.27-rc5 (root@faramir) ...
Sep  9 17:15:10 aragorn kernel: CE: increasing min_delta_ns 5000 to 10000 nsec
Sep  9 17:38:34 aragorn kernel: CE: increasing min_delta_ns 10000 to 20000 nsec
Sep  9 17:57:21 aragorn kernel: CE: increasing min_delta_ns 20000 to 40000 nsec
Sep  9 18:57:26 aragorn kernel: Back to C!
Sep  9 19:06:25 aragorn kernel: Back to C!
Sep  9 19:20:19 aragorn kernel: CE: increasing min_delta_ns 40000 to 80000 nsec

I also tried getting these on my desktop by switching the clocksource from
tsc to hpet, but that did not result in any output (identical x86_64 kernel).

Cheers,
FJP
