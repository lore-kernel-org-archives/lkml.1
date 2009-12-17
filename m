Return-Path: <linux-kernel-owner+w=401wt.eu-S1764237AbZLQJec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764237AbZLQJec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764227AbZLQJeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:34:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764215AbZLQJe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:34:28 -0500
Message-ID: <4B29FB11.5060100@redhat.com>
Date: Thu, 17 Dec 2009 17:34:09 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] direct_io: fix use after free in __blockdev_direct_IO
References: <1261039772-18403-1-git-send-email-dfeng@redhat.com> <20091217092942.GX14381@ZenIV.linux.org.uk>
In-Reply-To: <20091217092942.GX14381@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 05:29 PM, Al Viro wrote:
> On Thu, Dec 17, 2009 at 04:49:32PM +0800, Xiaotian Feng wrote:
>> @@ -1197,7 +1200,11 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>>   		(end>  i_size_read(inode)));
>>
>>   	retval = direct_io_worker(rw, iocb, inode, iov, offset,
>> -				nr_segs, blkbits, get_block, end_io, dio);
>> +				  nr_segs, blkbits, get_block, end_io,
>> +				  dio,&dio_freed);
>> +
>> +	if (dio_freed)
>> +		goto out;
>
> Um... I'm not sure that this would be the right fix.  How about simple
> s/dio->flags/flags/ in the line below?
Yes, dio->flags is not changed in direct_io_worker(), your method is 
better, thanks.

