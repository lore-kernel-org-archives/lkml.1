Return-Path: <linux-kernel-owner+w=401wt.eu-S1750855AbZIREVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbZIREVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 00:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZIREVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 00:21:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42127 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZIREVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 00:21:36 -0400
Message-ID: <4AB30AD1.7010400@us.ibm.com>
Date: Thu, 17 Sep 2009 21:21:37 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is nobh code still useful?
References: <20090917135627.GB13660@duck.suse.cz>
In-Reply-To: <20090917135627.GB13660@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
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
>   
Originally it was supported on ext2. I added support nobh support for 
ext3. At that time, the main
issue/complaint was that, these bufferheads consume memory from 
ZONE_NORMAL causing
memory pressure on 32-bit (i386) configurations.

Thanks,
Badari


