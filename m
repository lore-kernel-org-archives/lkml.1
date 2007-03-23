Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXCWOd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXCWOd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXCWOd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:33:57 -0400
Received: from holomorphy.com ([66.93.40.71]:34097 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXCWOd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:33:57 -0400
Date: Fri, 23 Mar 2007 07:33:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-ID: <20070323143324.GS2986@holomorphy.com>
References: <4603DE86.1090009@slax.org> <20070323151956.1ac6a47b.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323151956.1ac6a47b.dada1@cosmosbay.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 15:04:54 +0100 Tomas M <tomas@slax.org> wrote:
>> I posted this yesterday but it seems people didn't understand the real 
>> goal of my patch. So I will explain once more again:
>> This is a bugfix for loop.c block driver, as it currently allocates more 
>> memory then it needs, without any further use.

On Fri, Mar 23, 2007 at 03:19:56PM +0100, Eric Dumazet wrote:
> Well... changing the Changelog wont help I'm afraid.
> I cooked the following patch (untested), feel free to test it.

The array of preallocated garbage is to be killed by instantiating the
driver-private state at ->open() or at the time of file attachment or
whatever (I myself am not entirely sure of the right way to go about it).
I think someone's working on writing a patch of that form. I'm not sure
what they say is to be done about the gendisk array but I think there
are other ways to find the things by major and minor numbers.

IOW teaching loop.c to allocate more is not the way to go; one should
rather teach it to avoid doing all those allocations up-front.


-- wli
