Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbYGJOTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbYGJOTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYGJOTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:19:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24853 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbYGJOTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:19:12 -0400
Subject: Re: Higher than expected disk write(2) latency
From: Chris Mason <chris.mason@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Martin Lucina <mato@kotelna.sk>, Andrew Morton <akpm@linux-foundation.org>,
       Martin Sustrik <sustrik@fastmq.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org
In-Reply-To: <20080710070151.5fccbbcf@infradead.org>
References: <20080628121131.GA14181@nodbug.moloch.sk>
	 <20080709222701.8eab4924.akpm@linux-foundation.org>
	 <4875C45C.2010901@fastmq.com>
	 <20080710011417.95532d51.akpm@linux-foundation.org>
	 <1215696541.24425.214.camel@think.oraclecorp.com>
	 <20080710134144.GA31461@dezo.moloch.sk>
	 <20080710070151.5fccbbcf@infradead.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 10:18:32 -0400
Message-Id: <1215699512.24425.218.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 07:01 -0700, Arjan van de Ven wrote:
> On Thu, 10 Jul 2008 15:41:46 +0200
> Martin Lucina <mato@kotelna.sk> wrote:
> 
> > chris.mason@oracle.com said:
> > > Is NCQ enabled on the drive?  The basic way to fix this is to have
> > > multiple requests in flight, which isn't going to happen on sata
> > > with the cache off and with ncq off.
> > 
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: ATA-7: Hitachi HDS721616PLA380, P22OAB3A, max UDMA/133
> > ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 31/32)
> > ata1.00: configured for UDMA/133
> > 
> > I'm assuming the above indicates NCQ is enabled.
> > 
> > We'll try running the tests tomorrow with different i/o schedulers and
> > report back.
> 
> 
> another thing to try is using AHCI mode instead; AHCI tends to be
> higher performance
> 
> (and.. for fun try to run latencytop during a run, to see if maybe
> there are unsuspected delay causes)
> 
Any latencies during submit (at least for kernel aio) are probably from
get_request_wait, but the numbers so far look like they are only seeing
one request in flight at a time.

-chris


