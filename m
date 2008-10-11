Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYJKPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYJKPo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYJKPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:44:20 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57171 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbYJKPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:44:19 -0400
Subject: Re: libata: set queue SSD flag for SSD devices
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, torvalds@osdl.org
In-Reply-To: <20081011140600.GR19428@kernel.dk>
References: <200810101904.m9AJ42Gq018897@hera.kernel.org>
	 <20081010202515.446857cc@lxorguk.ukuu.org.uk>
	 <20081010200528.GJ19428@kernel.dk> <20081010175508.3d1ed2a4@infradead.org>
	 <1223710417.4159.11.camel@localhost.localdomain>
	 <20081011140600.GR19428@kernel.dk>
Content-Type: text/plain
Date: Sat, 11 Oct 2008 17:44:13 +0200
Message-Id: <1223739853.4159.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-11 at 16:06 +0200, Jens Axboe wrote:
> On Sat, Oct 11 2008, James Bottomley wrote:
> > On Fri, 2008-10-10 at 17:55 -0700, Arjan van de Ven wrote:
> > > On Fri, 10 Oct 2008 22:05:28 +0200
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > In this specific patch, it'll do no harm at least since I very much
> > > > doubt we'll see a false positive. And even if, the consequences wont
> > > > be dire. But it does want the version check, of course.
> > > > 
> > > 
> > > also, is "is an ssd" the right question or is "doesn't have seek
> > > latency" the right one?
> > > (difference is.. well EMC boxes with lots of ram etc)
> > 
> > For libata, the is ssd is the right test.
> > 
> > For things like the symmetrix we probably need to look at the caching
> > mode page and treat it like ssd if the cache is say > 1GB or whatever
> > heuristic is needed.
> 
> Still wont quite work, you're still going to have occasional seek
> latencies no matter how large the cache is (unless it's == device size
> :-)

True (just not very often) ... but statistically, the big symmetrixes
get better performance with the noop scheduler (which is treating them
like a SSD).  The occasional time they hiccough and seek tends to be
statistically in the noise.

As long as we do this stuff in userspace anyway, nothing needs to change
in the SCSI subsystem.

> So we need something a bit more involved, but not too complex. A fine
> line...

It's a policy ... just let userspace do it so the user can tune it.
That's what EMC does now (except I think they key of inquiry strings
rather than cache size).

James


