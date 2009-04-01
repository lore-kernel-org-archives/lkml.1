Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZDAPcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZDAPcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZDAPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:32:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:37462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZDAPcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:32:08 -0400
Message-ID: <49D38917.6010903@kernel.org>
Date: Thu, 02 Apr 2009 00:32:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 06/17] blk-map/bio: use struct iovec instead of sg_iovec
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-7-git-send-email-tj@kernel.org> <49D37F43.9000300@panasas.com>
In-Reply-To: <49D37F43.9000300@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 15:31:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> On 04/01/2009 04:44 PM, Tejun Heo wrote:
>> Impact: cleanup
>>
>> blk-map and bio use sg_iovec for addr-len segments although there
>> isn't anything sg-specific about the API.  This is mostly due to
>> historical reasons.  sg_iovec is by definition identical to iovec.
>> Use iovec instead.  This removes bogus dependency on scsi sg and will
>> allow use of iovec helpers.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> ---
>>  block/blk-map.c        |    5 ++---
>>  block/scsi_ioctl.c     |    8 +++-----
>>  fs/bio.c               |   23 +++++++++++------------
>>  include/linux/bio.h    |    6 +++---
>>  include/linux/blkdev.h |    8 ++++----
>>  5 files changed, 23 insertions(+), 27 deletions(-)
>>
> 
> OK, The actual one user in sg.c passes a void*, so no casts are
> needed. (I couldn't find where are the type-casts of old users)
> 
> Should we make this a part of a bigger cleanup that removes
> sg_iovec, from Kernel altogether and only makes a #define for
> user-mode?
> 
> BTW: 
>     user-mode scsi/sg.h does not come from the Kernels exported
>     headers. It comes with the gcc distribution.
>     If we remove it alltogether it will not affect anybody.
> 
> If you want I can help with this little chore?

Sure, that would be a nice cleanup.  If dropping sg_iovec doesn't
affect userland, I think it would better to just drop it.

Thanks.

-- 
tejun
