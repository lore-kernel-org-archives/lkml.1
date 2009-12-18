Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbZLRFtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbZLRFtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZLRFta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:49:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZLRFt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:49:29 -0500
Message-ID: <4B2B1852.6080105@cn.fujitsu.com>
Date: Fri, 18 Dec 2009 13:51:14 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: sniper <s3c24xx@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] btrfs: Simplify offset calculation method for ctree.h
References: <4B2ADB4C.7010900@cn.fujitsu.com> <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
In-Reply-To: <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sniper wrote:
> No, many pointers in btrfs function arguments are not pointing to an
> absolute address, but relative to the start address of extent.
> Take following function as example, argument inode_item is an offset
> value to the beginning of leaf. So we can't reach its member with
> &inode_item->xxx

Notice that we are not reach its member, we are getting pointer of its
member with &inode_item->mtime.
This operation have same effect as old one.

Thanks
Zhaolei

> 
>>  static inline struct btrfs_timespec *
>>  btrfs_inode_mtime(struct btrfs_inode_item *inode_item)
>>  {
>> -       unsigned long ptr = (unsigned long)inode_item;
>> -       ptr += offsetof(struct btrfs_inode_item, mtime);
>> -       return (struct btrfs_timespec *)ptr;
>> +       return &inode_item->mtime;
>>  }


