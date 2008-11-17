Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYKQCMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYKQCMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYKQCMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:12:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57383 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYKQCMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:12:21 -0500
Message-ID: <4920D238.8090905@cn.fujitsu.com>
Date: Mon, 17 Nov 2008 10:08:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Dave Airlie <airlied@gmail.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
References: <491FA28B.2070003@cn.fujitsu.com>	<20081115205229.765f7ee3@infradead.org>	<20081116.001926.150424480.davem@davemloft.net>	<20081116105725.12458b13@infradead.org>	<21d7e9970811161339x174d6041x1622d478f8e4247e@mail.gmail.com> <20081116135130.5e8b4e13@infradead.org>
In-Reply-To: <20081116135130.5e8b4e13@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 17 Nov 2008 07:39:55 +1000
> 
> I would go further than this.
> 
> Make the code just use vmalloc(). Period.
> 
> But then make vmalloc() smart and try do a direct mapping allocation
> first, before falling back to a virtual mapping. (and based on size it
> wouldn't even try it for just big things)
> 
> 
> 

Hi, Arjan van de Ven

(I'll rename simple_malloc/simple_free to kvmalloc/kvfree)

I think vmalloc() should only do one thing(virtual mapping). Your idea
can be implemented in helper function kvmalloc() if there is a good
algorithm provided for it.

kvmalloc() is for cleanup mostly. It will remove existed duplicate code.
As David and I pointed out, vmalloc() is need for some good reason.

If we do not introduce a helper function, these duplicate code
are still spread everywhere.


kvfree() is not only for free the memory allocated by kvmalloc().

kvfree() frees the memory that we don't know whether it was allocated
by kmalloc() nor vmalloc().

Someone use a flag for it, and other guys calculate size of memory again
before kfree() or vfree(). these two ways increase complexity, and
it is hard to prove the re-calculated size is reliable.

kvfree() will remove these needless complexity!



Thanx, Lai

