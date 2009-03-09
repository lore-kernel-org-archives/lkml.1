Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZCIDBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZCIDBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 23:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZCIDBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 23:01:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbZCIDBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 23:01:24 -0400
Date: Sun, 8 Mar 2009 20:00:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Arjan van de Ven <arjan@infradead.org>, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -v2] memdup_user(): introduce
Message-Id: <20090308200033.f5282b5b.akpm@linux-foundation.org>
In-Reply-To: <49B47D50.5000608@cn.fujitsu.com>
References: <49B0CAEC.80801@cn.fujitsu.com>
	<20090306082056.GB3450@x200.localdomain>
	<49B0DE89.9000401@cn.fujitsu.com>
	<20090306003900.a031a914.akpm@linux-foundation.org>
	<49B0E67C.2090404@cn.fujitsu.com>
	<20090306011548.ffdf9cbc.akpm@linux-foundation.org>
	<49B0F1B9.1080903@cn.fujitsu.com>
	<20090306150335.c512c1b6.akpm@linux-foundation.org>
	<20090307084805.7cf3d574@infradead.org>
	<49B47D50.5000608@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Mar 2009 10:22:08 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> >>> +EXPORT_SYMBOL(memdup_user);
> > 
> > Hi,
> > 
> > I like the general idea of this a lot; it will make things much less
> > error prone (and we can add some sanity checks on "len" to catch the
> > standard security holes around copy_from_user usage). I'd even also
> > want a memdup_array() like thing in the style of calloc().
> > 
> > However, I have two questions/suggestions for improvement:
> > 
> > I would like to question the use of the gfp argument here;
> > copy_from_user sleeps, so you can't use GFP_ATOMIC anyway.
> > You can't use GFP_NOFS etc, because the pagefault path will happily do
> > things that are equivalent, if not identical, to GFP_KERNEL.
> > 
> > So the only value you can pass in correctly, as far as I can see, is
> > GFP_KERNEL. Am I wrong?
> > 
> 
> Right! I just dug and found a few kmalloc(GFP_ATOMIC/GFP_NOFS)+copy_from_user(),
> so we have one more reason to use this memdup_user().

gack, those callsites are probably buggy.  Where are they?
