Return-Path: <linux-kernel-owner+w=401wt.eu-S936047AbYEBSi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936047AbYEBSi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762226AbYEBSip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:38:45 -0400
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:34347 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755822AbYEBSio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:38:44 -0400
Message-ID: <481B58EF.2030707@vlnb.net>
Date: Fri, 02 May 2008 22:09:51 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Bart Van Assche <bart.vanassche@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
References: <200805021638.42972.bart.vanassche@gmail.com>	 <20080502153306.GB7376@infradead.org>	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>	 <20080502155525.GA16353@infradead.org>	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com> <1209745084.3121.39.camel@localhost.localdomain>
In-Reply-To: <1209745084.3121.39.camel@localhost.localdomain>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2008-05-02 at 18:06 +0200, Bart Van Assche wrote:
>> On Fri, May 2, 2008 at 5:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
>>> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
>>>> Regarding out-of-tree modules: this is just a preparatory step before
>>>> submitting SCST for inclusion in the mainstream kernel.
>>> And what crackpipe did you smoke to thing we'd put duplicated target
>>> framework in?
>> Why are you so aggressive ? I didn't insult you in any way.
>>
>> Regarding inclusion of SCSI target code in the mainline, this subject
>> has already been discussed extensively in the past
>> (http://lkml.org/lkml/2008/1/23/134). The conclusion was clear: SCST
>> is faster than any other existing iSCSI target for Linux (IET, STGT,
>> LIO), stable, well maintained and the most standards compliant target.
>> Why do you want to reopen this discussion ?
> 
> That's an interesting rewrite of history.  The evidence you presented
> showed fairly identical results apart from on one contrived IB benchmark
> that couldn't directly compare the two.
> 
> I'm also on record in the thread saying that was insufficient proof for
> me to justify throwing STGT out and replacing it with SCST.

James, why do you keep ignoring important points, written by me in that 
e-mail: http://lkml.org/lkml/2008/1/30/178?

Namely:

1. Solid architecture of SCST is inherently more simple than distributed 
user/kernel space processing, when kernel behaves under control of user 
space, used in STGT, and allows to get better results with less effort. 
Better in all aspects: simplicity (hence, maintainability), reliability 
and performance. Linux once made step away from microkernel based design 
and that was for really good reasons.

2. Zero-copy operations with page cache will halve processing latency on 
high speed links, like InfiniBand, and it is impossible to implement 
that in a sane way with STGT approach, while for SCST it can be 
implemented simply and naturally.

Vlad

