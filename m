Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZHONWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZHONWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZHONWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:22:37 -0400
Received: from rtr.ca ([76.10.145.34]:50196 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbZHONWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:22:36 -0400
Message-ID: <4A86B69C.7090001@rtr.ca>
Date: Sat, 15 Aug 2009 09:22:36 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
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
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
  slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	 <20090813151312.GA13559@linux.intel.com>	 <20090813162621.GB1915@phenom2.trippelsdorf.de>	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>	 <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>	 <4A85E0DC.9040101@rtr.ca>	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>	 <20090814234539.GE27148@parisc-linux.org>	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com> <1250341176.4159.2.camel@mulgrave.site>
In-Reply-To: <1250341176.4159.2.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>
> This means you have to drain the outstanding NCQ commands (stalling the
> device) before you can send a TRIM.   If we do this for every discard,
> the performance impact will be pretty devastating, hence the need to
> coalesce.  It's nothing really to do with device characteristics, it's
> an ATA protocol problem.
..

I don't think that's really much of an issue -- we already have to do
that for cache-flushes whenever barriers are enabled.  Yes it costs,
but not too much.

The current problem is that the only existing SSDs in the wild with TRIM,
take 100s of milliseconds per TRIM, mostly regardless of the amount being
TRIMmed.  Sure, some TRIMs take only 10-20ms, and very large ones (millions
of sectors) can take 1-2 seconds, but most are in the 100ms range.

Cheers
