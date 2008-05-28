Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYE1MxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYE1MxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 08:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYE1MxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 08:53:06 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:43129 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYE1MxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 08:53:05 -0400
Message-ID: <483D4F73.5020503@hp.com>
Date: Wed, 28 May 2008 08:26:27 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-btrace@vger.kernel.org
Subject: Re: [PATCH] Changed blk trace msgs to directly use relay buffer
References: <483C1C5A.5000001@hp.com> <20080528121329.GU25504@kernel.dk>
In-Reply-To: <20080528121329.GU25504@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, May 27 2008, Alan D. Brunelle wrote:
> 
>> From 43c8ea2b78f31d7ccd349384a9a2084e787aafc1 Mon Sep 17 00:00:00 2001
>> From: Alan D. Brunelle <alan.brunelle@hp.com>
>> Date: Tue, 27 May 2008 10:32:36 -0400
>> Subject: [PATCH] Changed blk trace msgs to directly use relay buffer
>>
>> Allows for SMP-usage without corruption, and removes an extra copy at
>> the expense of copying extra bytes. Reduced message size from 1024 to 128.
> 
> Or, alternatively, something like the below. Then we don't
> unconditionally reserve and copy 128 bytes for each message, at the
> cost 128 bytes per-cpu per trace.

I looked into something like this, but thought the added complexity
wasn't worth it. Besides the extra per-cpu stuff, you also have an extra
memcopy involved - in my patch you print directly into the relay buffer.
I figure that /if/ copying (128-msg_size) extra bytes is too much, one
could always shrink the 128 down further. [I would think 64 bytes is
probably ok.]

I'd bet that the reduced complexity, and skipping the extra memcopy more
than offsets having to copy a few extra bytes...

Alan
