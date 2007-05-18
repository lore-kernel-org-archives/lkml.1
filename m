Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXERRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXERRed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXERRe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:34:27 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:34356 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXERRe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:34:26 -0400
Message-ID: <464DE395.9060207@namesys.com>
Date: Fri, 18 May 2007 21:34:13 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Richard Purdie <rpurdie@openedhand.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>  <20070516095018.6f0048bc.randy.dunlap@oracle.com>  <1179334843.5854.28.camel@localhost.localdomain>  <20070516100632.391f5459.akpm@linux-foundation.org> <1179345653.5854.41.camel@localhost.localdomain>
In-Reply-To: <1179345653.5854.41.camel@localhost.localdomain>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:

>On Wed, 2007-05-16 at 10:06 -0700, Andrew Morton wrote:
>  
>
>>On Wed, 16 May 2007 18:00:43 +0100 Richard Purdie <rpurdie@openedhand.com> wrote:
>>
>>    
>>
>>>On Wed, 2007-05-16 at 09:50 -0700, Randy Dunlap wrote:
>>>      
>>>
>>>>On Tue, 15 May 2007 20:19:14 -0700 Andrew Morton wrote:
>>>>
>>>>        
>>>>
>>>>>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
>>>>>          
>>>>>
>>>>LZO build fails on allyesconfig:
>>>>
>>>>lib/built-in.o: In function `lzo1x_1_compress':
>>>>lib/lzo/minilzo.c:724: multiple definition of `lzo1x_1_compress'                           fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1307: first defined here
>>>>ld: Warning: size of symbol `lzo1x_1_compress' changed from 1541 in fs/built-in.o to 244 in lib/built-in.o
>>>>lib/built-in.o: In function `lzo1x_decompress':                                            lib/lzo/minilzo.c:885: multiple definition of `lzo1x_decompress'
>>>>fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1466: first defined here                ld: Warning: size of symbol `lzo1x_decompress' changed from 1047 in fs/built-in.o to 678 in lib/built-in.o
>>>>make: *** [.tmp_vmlinux1] Error 1
>>>>make: Target `all' not remade because of errors.
>>>>        
>>>>
>>>Looks like reiser4 contains a copy of minilzo used as some kind of
>>>compression plugin. It can be dropped in favour of the version in
>>>lib/lzo/, they'll be compatible.
>>>
>>>Andrew: Do you want a patch to remove it from reiser4?
>>>
>>>      
>>>
>>yes please.
>>    
>>
>
>Sent.
>
>I also noticed that reiser4 is using lzo1x_decompress(), not
>lzo1x_decompress_safe(). The unsafe version is open to buffer overflows
>through malicious data since it performs no validation of where it
>writes output to.
>

Hm, if you accept unknown drive, then yes, it is open..

> I'm not sure whether thats acceptable in filesystem
>code, I'd suspect not?
>  
>

Ok, we will consider safe decompression,
moreover, as I remember, it doesn't lead to
sensible performance drop..

Thanks for this point,
Edward.

>Fixing it is a case of s/lzo1x_decompress(/lzo1x_decompress_safe(/ in 
>fs/reiser4/plugin/compress/compress.c...
>
>Richard
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>
>  
>

