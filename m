Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZDPGa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZDPGa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZDPGap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:30:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:40016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZDPGap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:30:45 -0400
Message-ID: <49E6D085.3050601@kernel.org>
Date: Thu, 16 Apr 2009 15:30:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com,
       James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with	blk_rq_map_kern_sgl()
References: <49E6A0B5.2090704@kernel.org> <20090416054457.GA13226@liondog.tnic> <49E6CB0D.3060307@kernel.org> <20090416062904.GA13487@liondog.tnic>
In-Reply-To: <20090416062904.GA13487@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Apr 2009 06:30:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Hi Tejun,
> 
> On Thu, Apr 16, 2009 at 03:07:09PM +0900, Tejun Heo wrote:
> 
> [..]
> 
>> There was another problem.  If we use blk_rq_map_kern() the failed rq
>> must be finished after the sense rq is finished because that's when
>> the bio is copied back if it was copied.  Before sense_rq completion,
>> the sense buffer doesn't contain any valid data.
> 
> Well, as an idea, we could just postpone the completion of the failed rq
> in:
> 
> if (sense && uptodate)
>         ide_cd_complete_failed_rq(drive, rq);
> 
> and put that just after
> 
> ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
> 
> line in cdrom_newpc_intr(). This way, we can copy back the sense data
> safely and then kill the rq.

Yeah, already have that in my patch.

> The only problem I fear with changes like that is that later some subtle
> interactions come about with some device which shouldn't normally
> happen. This is old code, you know, which still needs lots of scrubbing.
> It's like walking on a minefield :).

:-)

-- 
tejun
