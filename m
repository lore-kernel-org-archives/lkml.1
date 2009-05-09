Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZEIOEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZEIOEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZEIOEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:04:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:40734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZEIOEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:04:21 -0400
Message-ID: <4A058D5C.6030206@kernel.org>
Date: Sat, 09 May 2009 23:04:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com,
       dm-devel@redhat.com, dan.j.williams@gmail.com
Subject: Re: [PATCH 1/3] block: add alt_size
References: <1241828002-12742-1-git-send-email-tj@kernel.org> 	<1241828002-12742-2-git-send-email-tj@kernel.org> <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
In-Reply-To: <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 09 May 2009 14:03:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Kay Sievers wrote:
> What does "alt_" stand for? I think that should be more descriptive in
> an exported interface.

Alternative.

> And can we please keep the "size_*" in front of the name, so that they
> group together?

Maybe, but size_alt?  Any better ideas?

> Also, values with magic block counts, while there is no way to get the
> blocksize with the same interface, are pretty weird. I think the
> current "size" attribute is just a bug.

Logical block size is fixed at 512 bytes.  Offset and size are always
represented in multiples of 512 bytes and only get converted to
hardware block size in the lld.

> Not sure, how that should be solved, by adding a "blocksize" attribute
> that is always in the same context as the current "size*" values, or
> by just using bytes for new attributes here.
> 
> Almost all tools I've seen using these attributes, have hardcoded *
> 512 in there, which may cause trouble pretty soon. And this is mostly
> a failure of the interface and not of the users, I think.

No, it will never break.  It will always be 512.  It's there to give
nine bit shift to allow additional 9 bit of addressing without going
to the next full blown bitwidth.  It's chosen to be the lowest common
denominator which gives enough addressing boost to hold things
together till the next bitwidth becomes popular.

For userlevel exporting, it might have been better to use just bytes
there as preformance isn't really an issue, but, well, it's already
determined, so..

Thanks.

-- 
tejun
