Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZCICWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZCICWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 22:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZCICWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 22:22:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61295 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZCICWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 22:22:11 -0400
Message-ID: <49B47D50.5000608@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 10:22:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -v2] memdup_user(): introduce
References: <49B0CAEC.80801@cn.fujitsu.com>	<20090306082056.GB3450@x200.localdomain>	<49B0DE89.9000401@cn.fujitsu.com>	<20090306003900.a031a914.akpm@linux-foundation.org>	<49B0E67C.2090404@cn.fujitsu.com>	<20090306011548.ffdf9cbc.akpm@linux-foundation.org>	<49B0F1B9.1080903@cn.fujitsu.com>	<20090306150335.c512c1b6.akpm@linux-foundation.org> <20090307084805.7cf3d574@infradead.org>
In-Reply-To: <20090307084805.7cf3d574@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +EXPORT_SYMBOL(memdup_user);
> 
> Hi,
> 
> I like the general idea of this a lot; it will make things much less
> error prone (and we can add some sanity checks on "len" to catch the
> standard security holes around copy_from_user usage). I'd even also
> want a memdup_array() like thing in the style of calloc().
> 
> However, I have two questions/suggestions for improvement:
> 
> I would like to question the use of the gfp argument here;
> copy_from_user sleeps, so you can't use GFP_ATOMIC anyway.
> You can't use GFP_NOFS etc, because the pagefault path will happily do
> things that are equivalent, if not identical, to GFP_KERNEL.
> 
> So the only value you can pass in correctly, as far as I can see, is
> GFP_KERNEL. Am I wrong?
> 

Right! I just dug and found a few kmalloc(GFP_ATOMIC/GFP_NOFS)+copy_from_user(),
so we have one more reason to use this memdup_user().

