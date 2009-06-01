Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZFAXKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZFAXKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZFAXKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:10:08 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:49379 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZFAXKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:10:08 -0400
From: Frans Pop <elendil@planet.nl>
To: Luming Yu <luming.yu@gmail.com>
Subject: Re: [RFC patch] reset TSC at the begining of check_tsc_warp
Date: Tue, 2 Jun 2009 01:10:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <3877989d0906010201j438a08a8x559f62b0aed40696@mail.gmail.com>
In-reply-To: <3877989d0906010201j438a08a8x559f62b0aed40696@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906020110.06135.elendil@planet.nl>
X-OriginalArrivalTime: 01 Jun 2009 23:10:06.0279 (UTC) FILETIME=[1A0BAD70:01C9E30E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luming Yu wrote:
> Without this patch, we always get kernel warning that TSC warp between
> CPUs, and TSC is marked unstable due to check_tsc_sync_source failed if
> the CPUs have the problem of not-synced initial TSC.
> 
> It hurts CPUs with constant-tsc feature, but with unsynced initial TSC
> value...
> 
> The downside is we could break perfect synced TSC with this patch.
> Please review, test and apply.

I've tested this on my desktop (working TSC) and my laptop (non-working TSC).
On both machines the patch didn't make any difference.

Desktop: Intel mainboard, ICH7 chipset, dual core Pentium D 3.20GHz
$ dmesg | grep -i tsc
Fast TSC calibration using PIT
checking TSC synchronization [CPU#0 -> CPU#1]: passed.

Laptop: HP 2510p notebook, ICH8 chipset, Core2 Duo 1.33GHz
$ dmesg | grep -i tsc
Fast TSC calibration using PIT
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Marking TSC unstable due to TSC halts in idle
Clocksource tsc unstable (delta = -98164364 ns)

Tested on top of today's mainline git.

Cheers,
FJP
