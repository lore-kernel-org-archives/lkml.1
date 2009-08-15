Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZHONza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZHONza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZHONz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:55:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:49027 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZHONz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:55:28 -0400
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
From: James Bottomley <James.Bottomley@suse.de>
To: Mark Lord <liml@rtr.ca>
Cc: Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
In-Reply-To: <4A86B69C.7090001@rtr.ca>
References: <200908122007.43522.ngupta@vflare.org>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	 <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>
	 <4A85E0DC.9040101@rtr.ca>
	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
	 <20090814234539.GE27148@parisc-linux.org>
	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>
	 <1250341176.4159.2.camel@mulgrave.site>  <4A86B69C.7090001@rtr.ca>
Content-Type: text/plain
Date: Sat, 15 Aug 2009 08:55:17 -0500
Message-Id: <1250344518.4159.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-15 at 09:22 -0400, Mark Lord wrote:
> James Bottomley wrote:
> >
> > This means you have to drain the outstanding NCQ commands (stalling the
> > device) before you can send a TRIM.   If we do this for every discard,
> > the performance impact will be pretty devastating, hence the need to
> > coalesce.  It's nothing really to do with device characteristics, it's
> > an ATA protocol problem.
> ..
> 
> I don't think that's really much of an issue -- we already have to do
> that for cache-flushes whenever barriers are enabled.  Yes it costs,
> but not too much.

That's not really what the enterprise is saying about flush barriers.
True, not all the performance problems are NCQ queue drain, but for a
steady workload they are significant.

James

