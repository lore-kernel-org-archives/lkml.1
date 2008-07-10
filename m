Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYGJOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYGJOCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYGJOCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:02:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:35555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbYGJOCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:02:07 -0400
Date: Thu, 10 Jul 2008 07:01:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Martin Lucina <mato@kotelna.sk>
Cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Sustrik <sustrik@fastmq.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org
Subject: Re: Higher than expected disk write(2) latency
Message-ID: <20080710070151.5fccbbcf@infradead.org>
In-Reply-To: <20080710134144.GA31461@dezo.moloch.sk>
References: <20080628121131.GA14181@nodbug.moloch.sk>
	<20080709222701.8eab4924.akpm@linux-foundation.org>
	<4875C45C.2010901@fastmq.com>
	<20080710011417.95532d51.akpm@linux-foundation.org>
	<1215696541.24425.214.camel@think.oraclecorp.com>
	<20080710134144.GA31461@dezo.moloch.sk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 15:41:46 +0200
Martin Lucina <mato@kotelna.sk> wrote:

> chris.mason@oracle.com said:
> > Is NCQ enabled on the drive?  The basic way to fix this is to have
> > multiple requests in flight, which isn't going to happen on sata
> > with the cache off and with ncq off.
> 
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ATA-7: Hitachi HDS721616PLA380, P22OAB3A, max UDMA/133
> ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
> 
> I'm assuming the above indicates NCQ is enabled.
> 
> We'll try running the tests tomorrow with different i/o schedulers and
> report back.


another thing to try is using AHCI mode instead; AHCI tends to be
higher performance

(and.. for fun try to run latencytop during a run, to see if maybe
there are unsuspected delay causes)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
