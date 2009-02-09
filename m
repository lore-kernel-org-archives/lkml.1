Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZBIQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZBIQGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZBIQGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:06:12 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:38517 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZBIQGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:06:11 -0500
Subject: Re: Build failure with latest -git: btrfs on ppc64
From: Chris Mason <chris.mason@oracle.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090209155702.GB13529@bombadil.infradead.org>
References: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com>
	 <20090207232458.GB23407@bombadil.infradead.org>
	 <1234191446.1262.3.camel@think.oraclecorp.com>
	 <20090209155702.GB13529@bombadil.infradead.org>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 11:05:39 -0500
Message-Id: <1234195539.5447.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49905457.0036:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 10:57 -0500, Kyle McMartin wrote:
> On Mon, Feb 09, 2009 at 09:57:26AM -0500, Chris Mason wrote:
> > 
> > Ok, I thought this would be defined to something simple for the
> > non-ticket users, should I just not be using this call?  
> > 
> 
> I think the use is fine, since it's really a judgement call based on
> whether there's waiters for the ticket. I need to take a closer look
> at where this is used to say...
> 

The Btrfs use goes something like this:

I'm about to wait for the disk.  If there are other procs waiting for
the locks I'm holding, I'll drop my locks and do a somewhat expensive
btree search over again later so the waiters can make progress.

If nobody is waiting, I'll do my read with my locks held so that I don't
have to search again.

> It's inevitable for you to hit things like this though, as far as I know
> you're the first user of this lock interface. :)

;)

-chris


