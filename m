Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZG2ARe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZG2ARe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZG2ARd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:17:33 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:57297 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZG2ARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:17:32 -0400
Date: Tue, 28 Jul 2009 20:17:09 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andreas Mohr <andi@lisas.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Dynamic configure max_cstate
In-reply-to: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
Message-id: <alpine.LFD.2.00.0907282014030.17102@localhost.localdomain>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



thanks,
Len Brown, Intel Open Source Technology Center

On Mon, 27 Jul 2009, Andreas Mohr wrote:

> Hi,
> 
> > When running a fio workload, I found sometimes cpu C state has
> > big impact on the result. Mostly, fio is a disk I/O workload
> > which doesn't spend much time with cpu, so cpu switch to C2/C3
> > freqently and the latency is big.
> 
> Rather than inventing ways to limit ACPI Cx state usefulness, we should
> perhaps be thinking of what's wrong here.
> 
> And your complaint might just fit into a thought I had recently:
> are we actually taking ACPI Cx exit latency into account, for timers???

Yes.
menu_select() calls tick_nohz_get_sleep_length() specifically
to compare the expiration of the next timer vs. the expected sleep length.

The problem here is likely that the expected sleep length
is shorter than expected, for IO interrupts are not timers...
Thus we add long deep C-state wakeup time to the IO interrupt latency...

-Len Brown, Intel Open Source Technology Center

