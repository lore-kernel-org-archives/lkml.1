Return-Path: <linux-kernel-owner+w=401wt.eu-S1946146AbXBBW6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946146AbXBBW6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 17:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946152AbXBBW6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 17:58:11 -0500
Received: from rtr.ca ([64.26.128.89]:1491 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946149AbXBBW6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 17:58:08 -0500
Message-ID: <45C3C1FC.8020500@rtr.ca>
Date: Fri, 02 Feb 2007 17:58:04 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Ric Wheeler <ric@emc.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca> <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <45C2474E.9030306@rtr.ca> <1170366920.3388.62.camel@mulgrave.il.steeleye.com> <45C32C7F.9050706@emc.com> <20070202145003.525bd682@localhost.localdomain> <45C3617B.2020400@rtr.ca> <20070202194956.GF16722@waste.org>
In-Reply-To: <20070202194956.GF16722@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> ..
> Also worth considering is that spending minutes trying to reread
> damaged sectors is likely to accelerate your death spiral. More data
> may be recoverable if you give up quickly in a first pass, then go
> back and manually retry damaged bits with smaller I/Os.

All good input.  But what was being debated here is not so much
the retrying of known-bad sectors, but rather what to do about
the kiBs or MiBs of sectors remaining in a merged request after
hitting a single bad sector mid-way.

Currently, SCSI just abandons the entire remaining workload.

Cheers
