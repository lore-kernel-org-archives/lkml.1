Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZIQPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZIQPL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZIQPL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:11:28 -0400
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:43333 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752604AbZIQPL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:11:27 -0400
Message-ID: <4AB2519F.8020409@panasas.com>
Date: Thu, 17 Sep 2009 18:11:27 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090722 Remi/fc10 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>
CC: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       pbadari@us.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is nobh code still useful?
References: <20090917135627.GB13660@duck.suse.cz>
In-Reply-To: <20090917135627.GB13660@duck.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 15:11:31.0026 (UTC) FILETIME=[2308CB20:01CA37A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2009 04:56 PM, Jan Kara wrote:
>   Hi,
> 
>   during my page_mkwrite() work, I've looked at who uses nobh_ versions of
> various functions in fs/buffer.c. It seems only ext2 and jfs use them. ext3
> uses them only from writepage() (which means we needn't attach buffers to a
> page when it was written via mmap in writeback mode) and ext4 tries to use
> them but in fact it's nop because it always attaches buffers to the page
> earlier. So it's not really widely used, there's quite some code to support
> it (including one page flag), and it also slightly complicates my
> page_mkwrite() fixes.
>   So I wanted to ask does somebody actually remember what it is good for?
> Buffer heads obviously consume some memory so was that the reason? OTOH we
> have to map the page whenever we write to it or send it to disk via
> writepage().
> 
> 								Honza

I'm currently using nobh_truncate_page() in fs/exofs/inode.c::exofs_truncate().

Though, I suspect that once I do the conversion to Nick's:
	"[patch 00/11] new truncate sequence" 
and it is submitted, that use will disappear.

Thanks
Boaz
