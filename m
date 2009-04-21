Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZDUAC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZDUAC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZDUACs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:02:48 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:41515 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbZDUACr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:02:47 -0400
Message-ID: <49ED0D2C.40306@lougher.demon.co.uk>
Date: Tue, 21 Apr 2009 01:02:52 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: squashfs-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Chapman <doug.chapman@hp.com>
Subject: Re: [Squashfs-devel] [PATCH] squashfs broken when pageszie >	blocksize
References: <1239652637.1127.10.camel@oberon>	<49E3C209.5030705@lougher.demon.co.uk> <alpine.LRH.2.00.0904171518040.28718@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0904171518040.28718@vixen.sonytel.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> A quick grep on PAGE_{SIZE,SHIFT} in asm/page.h shows:
> 
> ia64, mips, sh: 4/8/16/64 KiB
> parisc: 4/16/64 KiB
> alpha, cris: 8 KiB
> powerpc: 4/16/64/256 KiB
> 
>> For completeness there should also be a mount time check that
>> the block size used in the Squashfs filesystem is at least as
>> large as the pagesize.  This doesn't matter for metadata
>> (size 8192), but does matter for data blocks, because Squashfs
>> read_page doesn't handle block_size < pagesize.
>>
>> Squashfs read_page used to handle block_size < pagesize but I
>> removed that code when I removed filesystem support for block_sizes
>> < 4K.  If ia64 users (or any other architecture with larger than
>> 4K pagesizes) want to use Squashfs filesystems with blocksizes less
>> than their pagesize, then I can put that code back in.
> 
> So I think it's a good idea to resurrect that code...
> 

Yes, something else to add to my ASAP TODO list.

Phillip
