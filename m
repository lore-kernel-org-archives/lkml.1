Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbXIJNwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbXIJNwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbXIJNwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:52:14 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:30311 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754235AbXIJNwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:52:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UO5P+ju2oh7F3ziyr3RiufbEBo7i4R2pk/SnUoQLkpqPTJzq9trMIGKA4yQ+A872inxywxwonxEiPydsZObP3wtnlQztivHJOTLVdc2y+G05HyVxzg9m8dN24u1cYpfcvkJHhuOQbmRIipYpeKK0TZidDGWdz8D+AzuWUZ786yo=  ;
X-YMail-OSG: Yfo0OIoVM1mXDBb_0rBCgbkekRfuUXG8ORNJ05rgzb007bCgCtSDdBFKBQLuWWoKpF9Ay1MB3rqDtnpkREwiwpQ8fO6e
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: tbench regression - Why process scheduler has impact on tbench and why small per-cpu slab (SLUB) cache creates the scenario?
Date: Mon, 10 Sep 2007 08:10:45 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
References: <1188953218.26438.34.camel@ymzhang> <200709081808.42421.nickpiggin@yahoo.com.au> <1189385792.14611.1.camel@ymzhang>
In-Reply-To: <1189385792.14611.1.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709100810.46341.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2007 10:56, Zhang, Yanmin wrote:
> On Sat, 2007-09-08 at 18:08 +1000, Nick Piggin wrote:
> > On Wednesday 05 September 2007 17:07, Christoph Lameter wrote:
> > > On Wed, 5 Sep 2007, Zhang, Yanmin wrote:
> > > > > slub_max_order=3 slub_min_objects=8
> > > >
> > > > I tried this approach. The testing result showed 2.6.23-rc4 is about
> > > > 2.5% better than 2.6.22. It really resovles the issue.
> > >
> > > Note also that the configuration you tried is the way SLUB is
> > > configured in Andrew's tree.
> >
> > It still doesn't sound like it is competitive with SLAB at the same
> > sizes. What's the problem?
>
> Process scheduler and small SLUB per-cpu cache work together to create the
> tebnch regression.

OK, so after isolating the scheduler, then SLUB should be as fast as SLAB
at the same allocation size. That's basically what we need to do before we
can replace SLAB with it, I think?
