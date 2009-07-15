Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZGOKq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZGOKq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZGOKq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:46:58 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42583 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbZGOKq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:46:57 -0400
Subject: Re: kmemleak reports
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5D148A.5090405@gmail.com>
References: <4A5D148A.5090405@gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 15 Jul 2009 11:46:27 +0100
Message-Id: <1247654787.10407.39.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2009 10:46:27.0856 (UTC) FILETIME=[8191A100:01CA0539]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 20:28 -0300, Kevin Winchester wrote:
> I have noticed a few kmemleak reports being sent to LKML in the last
> few days, and I could chime in with mine, if you wish:
> 
>     kmemleak: 97 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

That's not unlikely, though several of reports may come from a single
place (a user-space script could be used to group them together).

> The entries are for X, ntpdate, scsi_scan_2, softirq, swapper, in case
> there's anything surprising in there.

As I mentioned in the past, you can run a few "echo scan
> /sys/kernel/debug/kmemleak" to see if any of them disappear.

> However, I was thinking that you might soon start getting too many
> reports to process.  I wonder if there might be some way that you
> could have a similar facility to kerneloops that would automatically
> register leak reports to a website where they could be organized and
> ranked by number of occurrences.  Are the individual leaks reported in
> such at way that would allow them to be grouped like that?

The leaks are reported in the order they were allocated and this makes
it easier to debug (since an early leak may trigger subsequent reports
on pointers it contains since it isn't scanned).

My hope is that once the initial leaks are fixed, there will be less in
the future and could be easily linked to recent commits (which is not
always the case now).

I don't have the time to set up something like kerneloops but I'm happy
to manually log them somewhere (like bugzilla.kernel.org).
Alternatively, kerneloops.org could detect kmemleak reports on the list
and log them.

> If a kerneloops-style setup is not desirable/feasible, would you be
> able to send me a walkthrough for how you go about tracking down one
> of these leaks?  Then I might be able to help out by investigating a
> few of my own.

First, make sure you use -rc3 as it has several kmemleak fixes. On
x86_64, there is another patch I posted for moving the _edata in
vmlinux.lds.S to be able to scan the whole .data section.

I gave some hints in this message - http://lkml.org/lkml/2009/7/14/72.
I'll also update the Documentation/kmemleak.txt file with such
information in the next few days.

-- 
Catalin

