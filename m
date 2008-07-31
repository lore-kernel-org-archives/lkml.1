Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYGaHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYGaHcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYGaHcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:32:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYGaHb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:31:59 -0400
Message-ID: <48916A0F.1000500@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 15:30:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] vfs: filp is never NULL in do_generic_file_read()
References: <20080730130845.905327725@szeredi.hu> <20080730130914.500576799@szeredi.hu> <20080731161554.3C84.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080731161554.3C84.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>  	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
>> -	if (filp)
>> -		file_accessed(filp);
>> +	file_accessed(filp);
>>  }
>>  
>>  int file_read_actor(read_descriptor_t *desc, struct page *page,
> 
> if filp is never NULL, BUG_ON is better?
> 

static inline void file_accessed(struct file *file)
{
	if (!(file->f_flags & O_NOATIME))
		...
}

So if filp is NULL, we'll get a noisy NULL dereference bug immediately,
so BUG_ON() is not needed.


