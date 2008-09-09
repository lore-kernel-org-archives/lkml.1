Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYIIQ5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYIIQ5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYIIQ5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:57:23 -0400
Received: from nebensachen.de ([195.34.83.29]:56531 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbYIIQ5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:57:23 -0400
X-Hashcash: 1:20:080909:jens.axboe@oracle.com::T/3HODkFTyw2vLRE:00000000000000000000000000000000000000001RcL
X-Hashcash: 1:20:080909:fujita.tomonori@lab.ntt.co.jp::zkANwodVXubTkPpz:000000000000000000000000000000000Dys
X-Hashcash: 1:20:080909:greg@kroah.com::g8h0JKuFYdFMDvN8:0000DrY
X-Hashcash: 1:20:080909:linux-kernel@vger.kernel.org::3FgDTkeJE1JXGSaQ:0000000000000000000000000000000000nKX
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: Block: Trouble with kobject initialisation for blk_cmd_filter
References: <87od3235fc.fsf@denkblock.local>
	<20080909102844.GD20055@kernel.dk>
	<20080909214602L.fujita.tomonori@lab.ntt.co.jp>
	<20080909131850.GL20055@kernel.dk>
Date: Tue, 09 Sep 2008 18:57:05 +0200
In-Reply-To: <20080909131850.GL20055@kernel.dk> (Jens Axboe's message of "Tue,
	9 Sep 2008 15:18:52 +0200")
Message-ID: <87prndp89q.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Sep 09 2008, FUJITA Tomonori wrote:
[...]
>> The sysfs changes looks too much for 2.6.27-rcX but without the sysfs
>> changes, we have the cmdfilter under /sys/block/sda/queue/, right? We
>> don't need to worry about compatibility, but /sys/block/sda is more
>> appropriate? (though I don't think that the cmd filter is a good idea
>> so I don't care much).
>
> I agree, under sda/ makes a lot more sense than under sda/queue/

Well, but why is it in struct request_queue then? Is it going to be
moved back to the gendisk eventually?

>
>> Jens, would it be better to just disable the cmdfilter stuff for
>> 2.6.27? It's too late for another try to fix this broken stuff, I
>> guess.
>
> Yeah, it's certainly starting to look like it... The amount of changes
> to unbreak it are too large to submit now, so lets postpone it until
> 2.6.28.

I won't bother with the patch against 2.6.27-rc then. What about 2.6.28
though? Not that I really care whether the cmd_filter appears under sda/
or sda/queue/, I just wanted to point out that the sysfs code can be
simplified considerably. The things I do care about, of course, are the
two problems that have been fixed by my patch: There are no spurious
warnings and stack dumps due to kobject reinitialisation and the
cmd_filter sysfs interface inherits proper locking. Please take this
into consideration if you decide not to reuse the queue layer sysfs
interface. Otherwise, just let me know if you want me to port the patch
(just the cmd_filter part or the sysfs stuff as well) to next-200809..

Regards,

Elias
