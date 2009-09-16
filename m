Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZIPIZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZIPIZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZIPIZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:25:12 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:46364 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599AbZIPIZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pNdiw14h1zW8hB9QmbkXXQ/V/j/0tVRb9HNV4iGkQjaYN7tS0Lsfb570se1Q98uetx
         xNJnmdizdu6KTEzUyAwi3D6F/T4R7hT7bPPd4mmFFx6XdosqYAvpf+zmklV0O2k02Mjb
         nPjIJafmiR+TduMx0wrI4Jg7UzCjgyAeKZV78=
MIME-Version: 1.0
In-Reply-To: <20090916092644.fb53279a.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
	 <20090916092644.fb53279a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 16 Sep 2009 16:25:12 +0800
Message-ID: <2375c9f90909160125x5ec67af0p3a25a555d30d38a3@mail.gmail.com>
Subject: Re: [BUGFIX][mmotm] fix walk system ram range patch (Was Re: mmotm on 
	powerpc: walk_memory_resource?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/16 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> On Tue, 15 Sep 2009 22:36:26 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
>
>> Recent mmotm builds on powerpc have been failing with
>>
>> arch/powerpc/mm/mem.c:169: error: ‘walk_memory_resource’ undeclared here (not in a function)
>> cc1: warnings being treated as errors
>> arch/powerpc/mm/mem.c:169: error: type defaults to ‘int’ in declaration of ‘walk_memory_resource’
>> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
>>
> Thank you for pointing out.
> -Kame
> ==
>
>
> walk-system-ram-range.patch renames walk_memory_resource()
> to be walk_system_ram_range().
> But powerpc has its own one and it's exported.
> (Because ehea driver (IBM's one) uses this, powerpc export this.)
>
>> arch/powerpc/mm/mem.c:169: error: ‘walk_memory_resource’ undeclared here (not in a function)
>> cc1: warnings being treated as errors
>> arch/powerpc/mm/mem.c:169: error: type defaults to ‘int’ in declaration of ‘walk_memory_resource’
>> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
>>
> The patch failed to update powerpc's EXPORT_SYMBOL, this patch fixes it.
>
> Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
> ---
>  arch/powerpc/mm/mem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
> ===================================================================
> --- mmotm-2.6.31-Sep14.orig/arch/powerpc/mm/mem.c
> +++ mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
> @@ -166,7 +166,7 @@ walk_system_ram_range(unsigned long star
>        }
>        return ret;
>  }
> -EXPORT_SYMBOL_GPL(walk_memory_resource);
> +EXPORT_SYMBOL_GPL(walk_system_ram_range);
>
>  /*
>  * Initialize the bootmem system and give it all the memory we
>
