Return-Path: <linux-kernel-owner+w=401wt.eu-S1763198AbXHARfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763198AbXHARfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbXHARfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:35:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:20669 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbXHARf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LFEFtI/4jxCj+nvbCFL6QYoOa1svfvK6ZYBpnGdoaIoHOmbDdVsCKfNyblX3zGNfhLZxfscZrlL/mLvQgs5CtK5tw58rBr5zPPWphIQJGwztE2Z5wo6qSU7dqIMN5MafiuHmsQFOwlZPYg+sxxJiQ8yI5VQLmqikKmUkNSWX5fc=
Message-ID: <46B0C448.4030703@googlemail.com>
Date: Wed, 01 Aug 2007 19:35:04 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, ezk@cs.sunysb.edu, jsipek@cs.sunysb.edu
Subject: Re: unionfs compile error ( Re: 2.6.23-rc1-mm2 )
References: <20070731230932.a9459617.akpm@linux-foundation.org>	<46B0616E.5000704@googlemail.com> <20070801102207.f427a17f.akpm@linux-foundation.org>
In-Reply-To: <20070801102207.f427a17f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 01 Aug 2007 12:33:18 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> ....
>>
>> fs/unionfs/file.c:147: error: 'file_fsync' undeclared here (not in a function)
>> make[2]: *** [fs/unionfs/file.o] Error 1
>> make[1]: *** [fs/unionfs] Error 2
>> make: *** [fs] Error 2
>> make: *** Waiting for unfinished jobs....
>>
>> ...
>>
>> Config can be found there -> http://194.231.229.228/MM/config-auto-3
>>
> 
> This, I assume:

Yes this fixes it.

> 
> --- a/fs/unionfs/file.c~git-unionfs-fix-2
> +++ a/fs/unionfs/file.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include "union.h"
> +#include <linux/buffer_head.h>
>  
>  /*******************
>   * File Operations *
> _
> 
> (and no, sorry, I will not be complicit in that
> single-header-file-which-includes-the-whole-world junk).
> 
> 
