Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXLMTxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXLMTxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbXLMTxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:53:24 -0500
Received: from rtr.ca ([76.10.145.34]:2449 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXLMTxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:53:23 -0500
Message-ID: <47618DB1.6030408@rtr.ca>
Date: Thu, 13 Dec 2007 14:53:21 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, Neil Brown <neilb@suse.de>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca> <47617E72.6080504@rtr.ca> <20071213185326.GQ26334@parisc-linux.org> <4761821F.3050602@rtr.ca> <20071213192633.GD10104@kernel.dk>
In-Reply-To: <20071213192633.GD10104@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Dec 13 2007, Mark Lord wrote:
>> Matthew Wilcox wrote:
>>> On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
>>>> Problem confirmed.  2.6.23.8 regularly generates segments up to 64KB for 
>>>> libata,
>>>> but 2.6.24 uses only 4KB segments and a *few* 8KB segments.
>>> Just a suspicion ... could this be slab vs slub?  ie check your configs
>>> are the same / similar between the two kernels.
>> ..
>>
>> Mmmm.. a good thought, that one.
>> But I just rechecked, and both have CONFIG_SLAB=y
>>
>> My guess is that something got changed around when Jens
>> reworked the block layer for 2.6.24.
>> I'm going to dig around in there now.
> 
> I didn't rework the block layer for 2.6.24 :-). The core block layer
> changes since 2.6.23 are:
> 
> - Support for empty barriers. Not a likely candidate.
> - Shared tag queue fixes. Totally unlikely.
> - sg chaining support. Not likely.
> - The bio changes from Neil. Of the bunch, the most likely suspects in
>   this area, since it changes some of the code involved with merges and
>   blk_rq_map_sg().
> - Lots of simple stuff, again very unlikely.
> 
> Anyway, it sounds odd for this to be a block layer problem if you do see
> occasional segments being merged. So it sounds more like the input data
> having changed.
> 
> Why not just bisect it?
..

CC'ing Neil Brown.

