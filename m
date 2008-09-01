Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYIAIbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYIAIbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYIAIbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:31:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:11216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYIAIbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=L3RfCell2+d8jZZVspzJcGZVh6Gj+am5R5e9jCas41g9uXf/79j3vkZ9G0z/ltm/uB
         rFSEp8WTdVMTj+syygk3KGnmOon54yz9Pyg4BozOQINO6MUpru6B6THHfJy6xS5kTEv2
         qZPA3wVEBMkTpLkM7gidr7W9iiMaiholoXg0A=
Message-ID: <48BBA85F.2010906@panasas.com>
Date: Mon, 01 Sep 2008 11:31:27 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Korty <joe.korty@ccur.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shrink printk timestamp field
References: <20080827151759.GA10678@tsunami.ccur.com>	<20080829163540.634e86d9.akpm@linux-foundation.org>	<20080830143808.GA10821@tsunami.ccur.com> <20080830101618.b6c2e1ab.akpm@linux-foundation.org>
In-Reply-To: <20080830101618.b6c2e1ab.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug. 30, 2008, 20:16 +0300, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 30 Aug 2008 10:38:08 -0400 Joe Korty <joe.korty@ccur.com> wrote:
> 
>> On Fri, Aug 29, 2008 at 07:35:40PM -0400, Andrew Morton wrote:
>>> On Wed, 27 Aug 2008 11:17:59 -0400 Joe Korty <joe.korty@ccur.com> wrote:
>>>
>>>> Shrink the printk timestamp field.
>>>>
>>>> Keep the printk timestamp from occupying more of the
>>>> scarce, 80-column console line space than it really needs.
>>>>
>>> This is a significant loss in utility.
>>>
>>> [   16.817285] md: Autodetecting RAID arrays.
>>> [   16.817288] md: Scanned 0 and added 0 devices.
>>> [   16.817290] md: autorun ...
>>> [   16.817292] md: ... autorun DONE.
>>>
>>> This not-terribly-fast machine can emit printks into the log buffer
>>> within two microseconds.  That's a pretty useful ad-hoc timing
>>> factility.
>>>
>>> This patch will reduce the precision by a factor of five hundred.
>> I was looking at it from the point of view of finding out where the
>> boot process was too slow.  For that millisecs is enough.  I am not
>> sure where knowing printk output to the microsec would be useful for
>> solving anything.
>>
> 
> Of course it's useful.  If you're working on performance or latency in
> a disk, network or USB driver, microsecond resolution is about right.

How about supporting a configurable format string either by .config
and/or in runtime, e.g. given by a command line parameter?

Benny

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

