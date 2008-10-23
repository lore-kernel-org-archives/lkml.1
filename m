Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYJWI4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYJWI4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYJWI4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:56:09 -0400
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:4445 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYJWI4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:56:08 -0400
Message-ID: <49003C35.1090301@lougher.demon.co.uk>
Date: Thu, 23 Oct 2008 09:56:21 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 12/16] Squashfs: header files
References: <E1KqrTX-0001y4-JE@dylan> <Pine.LNX.4.64.0810221801570.5634@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0810221801570.5634@vixen.sonytel.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Fri, 17 Oct 2008, Phillip Lougher wrote:

>> +#ifdef SQUASHFS_TRACE
>> +#define TRACE(s, args...)	printk(KERN_NOTICE "SQUASHFS: "s, ## args)
>> +#else
>> +#define TRACE(s, args...)	{}
>> +#endif
> 
> Just use
> 
>     #define TRACE(s, args...)	pr_debug("SQUASHFS: "s, ## args)

OK.

>> +
>> +#define WARNING(s, args...)	printk(KERN_WARNING "SQUASHFS: "s, ## args)
>                                 ^^^^^^^^^^^^^^^^
> 				pr_warning(
> 

OK.

> 
> SQUASHFS_MKFLAGS() isn't used by the kernel, only by the tools (mksquashfs)?
> 

Only used by mksquashfs.  I pulled out the user-space only stuff into a 
separate include, but must have missed this one.

>> +/* meta index cache */
>> +#define SQUASHFS_META_INDEXES	(SQUASHFS_METADATA_SIZE / sizeof(unsigned int))
>                                                                          ^^^^^^^^^^^^
> I was wondering whether a meta index is an `unsigned int' or an `__le32', but I
> couldn't find it easily.
> 

Unsigned int, it's used internally by the index cache code (file.c).  It 
works out how many block indexes can fit into one compressed metadata block.

Phillip
