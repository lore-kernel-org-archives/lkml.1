Return-Path: <linux-kernel-owner+w=401wt.eu-S933436AbZDBJDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436AbZDBJDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762926AbZDBJDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:03:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:47325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705AbZDBJDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:03:08 -0400
Message-ID: <49D47F3F.7000105@kernel.org>
Date: Thu, 02 Apr 2009 18:02:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 05/17] bio: cleanup rw usage
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-6-git-send-email-tj@kernel.org> <49D47925.5050307@panasas.com>
In-Reply-To: <49D47925.5050307@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 09:02:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 04/01/2009 04:44 PM, Tejun Heo wrote:
>> Impact: cleanup
>>
>> bio confusingly uses @write_to_vm and @reading for data directions,
>> both of which mean the opposite of the usual block/bio convention of
>> using READ and WRITE w.r.t. IO devices.  The only place where the
>> inversion is necessary is when caling get_user_pages_fast() in
>> bio_copy_user_iov() as the gup uses the VM convention of read/write
>> w.r.t. VM.
>>
>> This patch converts all bio functions to use READ/WRITE rw parameter
>> and let the one place where inversion is necessary to rw == READ.
>>
> 
> Hi one more nit picking just if you are at it. If you want
> I can do the work and send it to you so you can squash it into this patch.
> See bellow
> 
>> +	if (rw == WRITE)
>> +		bio->bi_rw |= 1 << BIO_RW;
> 
> can we pleas have an inline that does that? Like bio_set_dir()?
> and change all users. You will be surprised how many there are.
> 
> It gives me an hart attack every time I have to write yet another
> one.

Things like this are actually what I'm trying to clean up.  If you
look at the whole series, at the end, there remains only one place
which sets the flag in the blk/bio map paths and all users of
blk_rq_map_*() interface couldn't care less about the flag because
they provide only the necessary information through strictly defined
API.

Thanks.

-- 
tejun
