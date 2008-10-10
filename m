Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYJJIJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYJJIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYJJIJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:09:14 -0400
Received: from corega.com.ru ([195.178.208.66]:32979 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYJJIJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:09:13 -0400
Date: Fri, 10 Oct 2008 12:09:10 +0400
From: Evgeniy Polyakov <s0mbre@tservice.net.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081010080910.GA31723@tservice.net.ru>
References: <20081009231759.GA8664@tservice.net.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009231759.GA8664@tservice.net.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter.

I've enabled kernel hacking option and scheduler debugging and turned
off hrticks and performance jumped to 382 MB/s:

vanilla 27: 347.222
no TSO/GSO: 357.331
no hrticks: 382.983

I use tsc clocksource, also available acpi_pm and jiffies,
with acpi_pm performance is even lower (I stopped test after it dropped
below 340 MB/s mark), jiffies do not work at all, looks like sockets
stuck in time_wait state when this clock source is used, although that
may be some different issue.

So I think hrticks are guilty, but still not as good as .25 tree without
mentioned changes (455 MB/s) and .24 (475 MB/s).

-- 
	Evgeniy Polyakov
