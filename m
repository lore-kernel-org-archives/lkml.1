Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZG2PK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZG2PK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZG2PK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:10:26 -0400
Received: from fifo99.com ([67.223.236.141]:43611 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZG2PKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:10:25 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090729134125.313191633@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 08:10:42 -0700
Message-Id: <1248880242.28841.185.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> There is still more room for improvement. Some sore points are:
> 
> 1) The cycle_last value still is in the struct clocksource. It should
>    be in the struct timekeeper but the check against cycles_last in
> the
>    read function of the TSC clock source makes it hard.
> 2) read_persistent_clock returns seconds. With a really good initial
>    time source this is not very precise. read_persistent_clock should
>    return a struct timespec.
> 3) xtime, raw_time, total_sleep_time, timekeeping_suspended, jiffies,
>    the ntp state and probably a few other values may be better located
>    in the struct timekeeper as well.


You could also consolidate the clocksource_unregister() path and the
clocksource_change_rating(0) path  , both are basically doing the same
thing.. Neither one is heavily used..

Daniel

