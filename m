Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbZDAOLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbZDAOLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZDAOGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:06:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:55339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179AbZDAOGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:06:12 -0400
Message-ID: <49D374C8.7000909@kernel.org>
Date: Wed, 01 Apr 2009 23:06:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 15/17] bio/blk-map: kill unused stuff and un-export internal
 functions
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-16-git-send-email-tj@kernel.org> <49D371FF.3050202@panasas.com>
In-Reply-To: <49D371FF.3050202@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 14:06:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> On 04/01/2009 04:44 PM, Tejun Heo wrote:
>> Impact: cleanup, removal of unused / undesirable API
>>
>> With recent changes, the following functions aren't used anymore.
>>
>> * bio_{map|copy}_{user|kern}()
>> * blk_rq_append_bio()
>>
> 
> This function is used by drivers/scsi/osd/osd_initiator.c
> Currently in mainline. Please use allmodconfig to compile
> everything.

The patchse is against Jens's tree which hasn't received the changes
yet and I did allmodconfig.

>> The following functions aren't used outside of block layer.
>>
>> * bio_add_pc_page()
> 
> And also this
>
>> * bio_un{map|copy}_user()
>>
>> Kill the first group and unexport the second.  As bio_add_pc_page() is
>> used only inside fs/bio.c, it's made static.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> I've posted propositions on how to fix osd_initiator.c which
> involves making blk_map_kern() append to the request, and a new
> blk_make_request(bio).

Yeap, I'll take a look at that.

Thanks.

-- 
tejun
