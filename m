Return-Path: <linux-kernel-owner+w=401wt.eu-S1767016AbXDEOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767016AbXDEOss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767025AbXDEOss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:48:48 -0400
Received: from stinky.trash.net ([213.144.137.162]:52602 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767016AbXDEOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:48:47 -0400
Message-ID: <46150C49.4050800@trash.net>
Date: Thu, 05 Apr 2007 16:48:41 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: leon zadorin <leonleon77@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: "no hz"/"dynamic tick" option and TC/TBF (token bucket filter)
 behaviour...
References: <26d2cb010704050736y775b6b09g67fd40344cd2208d@mail.gmail.com>
In-Reply-To: <26d2cb010704050736y775b6b09g67fd40344cd2208d@mail.gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

leon zadorin wrote:
> 2) for kernels which do have the aforementioned option enabled: how
> does this affect the "tc" (traffic control) utility and the Token
> Bucket Filter (tbf) queueing discipline (traffic-smoothing)
> behhaviour?
> 
> For example, the TBF doco suggests that due to the whole fixed Hz
> thing in the kernel (e.g. 100Hz) the maximum rate of the TBF would
> actually be limited to say 1mbit on Intel arch (with the default
> mtu... but if mtu is incleased, so is the burstiness of the traffic
> which is what TBF is trying to prevent in my deployment scenarios).
> ...
> 
> So what about the kernels which use this "dyna tick" option - in such
> a kernel, will there be an interrupt generated (e.g. at microsec.
> precision on most platforms) for every packet's send time (e.g. say at
> TBF's rate is at 25Mbps and one sends out 1KB data packets... will
> there be  an interrput generated every... 300 microseconds?)...


No, it doesn't affect the timer resolution. net-2.6.22 includes
patches that switch all qdiscs to hrtimers, which allows to use
much smaller burst rates.

