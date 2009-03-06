Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZCFJCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZCFJCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZCFJBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:01:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54766 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZCFJBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:01:52 -0500
Message-ID: <49B0E67C.2090404@cn.fujitsu.com>
Date: Fri, 06 Mar 2009 17:01:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
References: <49B0CAEC.80801@cn.fujitsu.com>	<20090306082056.GB3450@x200.localdomain>	<49B0DE89.9000401@cn.fujitsu.com> <20090306003900.a031a914.akpm@linux-foundation.org>
In-Reply-To: <20090306003900.a031a914.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 06 Mar 2009 16:27:53 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>>> Let's not add wrapper for every two lines that happen to be used
>>> together.
>>>
>> Why not if we have good reasons? And I don't think we can call this
>> "happen to" if there are 250+ of them?
> 
> The change is a good one.  If a reviewer (me) sees it then you know the
> code's all right and the review effort becomes less - all you need to check
> is that the call site is using IS_ERR/PTR_ERR and isn't testing for
> NULL.  Less code, less chance for bugs.
> 
> Plus it makes kernel text smaller.
> 
> Yes, the name is a bit cumbersome.
> 

How about memdup_user()? like kstrndup() vs strndup_user().

Here is the statistics when using 5 kmemdup_from_user() in btrfs:

$ diffstat
 ioctl.c |   49 ++++++++++++-------------------------------------
 super.c |   13 ++++---------
 2 files changed, 16 insertions(+), 46 deletions(-)

the kernel size on i386:

   text    data     bss     dec     hex filename
 288339    1924     508  290771   46fd3 fs/btrfs/btrfs.o.orig
   text    data     bss     dec     hex filename
 288255    1924     508  290687   46f7f fs/btrfs/btrfs.o

so saves 84 bytes.

the kernel size on IA64:

   text    data     bss     dec     hex filename
 898752    3736     109  902597   dc5c5 fs/btrfs/btrfs.o.orig
   text    data     bss     dec     hex filename
 898176    3712     109  901997   dc36d fs/btrfs/btrfs.o

so saves 576 bytes.
