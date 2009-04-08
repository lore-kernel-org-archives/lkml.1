Return-Path: <linux-kernel-owner+w=401wt.eu-S935289AbZDHUHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935289AbZDHUHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935230AbZDHUGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:06:44 -0400
Received: from relay3.sgi.com ([192.48.156.57]:39435 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935225AbZDHUGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:06:42 -0400
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Message-Id: <ACCF081B-8013-487F-A4FC-1B18B44D8F52@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090408132254.GA5957@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 4/6] xfs: use memdup_user()
Date: Wed, 8 Apr 2009 15:06:40 -0500
References: <49DC4CC0.9050805@cn.fujitsu.com> <49DC4D54.3020001@cn.fujitsu.com> <20090408132254.GA5957@infradead.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8, 2009, at 8:22 AM, Christoph Hellwig wrote:

> On Wed, Apr 08, 2009 at 03:08:04PM +0800, Li Zefan wrote:
>> Remove open-coded memdup_user()
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>> fs/xfs/linux-2.6/xfs_ioctl.c   |   23 +++++++----------------
>> fs/xfs/linux-2.6/xfs_ioctl32.c |   12 ++++--------
>> 2 files changed, 11 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/ 
>> xfs_ioctl.c
>> index d0b4994..34eaab6 100644
>> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
>> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
>> @@ -489,17 +489,12 @@ xfs_attrmulti_attr_set(
>> 	if (len > XATTR_SIZE_MAX)
>> 		return EINVAL;
>>
>> -	kbuf = kmalloc(len, GFP_KERNEL);
>> -	if (!kbuf)
>> -		return ENOMEM;
>> -
>> -	if (copy_from_user(kbuf, ubuf, len))
>> -		goto out_kfree;
>> +	kbuf = memdup_user(ubuf, len);
>> +	if (IS_ERR(kbuf))
>> +		return PTR_ERR(kbuf);
>
> wouldn't NULL be a better error return for this kind of interface,
> matching kmalloc?
>
>
> Otherwise the patch looks good to me.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me too.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

p.s. Replying to reply as I couldn't find the original post.

