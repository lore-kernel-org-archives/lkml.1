Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbZHNXpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbZHNXpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 19:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbZHNXpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 19:45:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38293 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbZHNXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 19:45:39 -0400
Date: Fri, 14 Aug 2009 17:45:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Chris Worley <worleys@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
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
Message-ID: <20090814234539.GE27148@parisc-linux.org>
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <20090813151312.GA13559@linux.intel.com> <20090813162621.GB1915@phenom2.trippelsdorf.de> <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm> <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com> <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm> <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com> <4A85E0DC.9040101@rtr.ca> <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 05:21:32PM -0600, Chris Worley wrote:
> Sooner is better than waiting to coalesce.  The longer an LBA is
> inactive, the better for any management scheme.  If you wait until
> it's reused, you might as well forgo the advantages of TRIM/UNMAP.  If
> a the controller wants to coalesce, let it coalesce.

I'm sorry, you're wrong.  There is a tradeoff point, and it's different
for each drive model.  Sending down a steady stream of tiny TRIMs is
going to give terrible performance.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
