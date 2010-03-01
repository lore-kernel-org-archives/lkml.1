Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0CAKyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:54:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:51822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab0CAKyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:54:41 -0500
Date: Mon, 1 Mar 2010 11:54:51 +0100
From: Jan Kara <jack@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>,
       linux-m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] udf: use ext2_find_next_bit
Message-ID: <20100301105450.GC3271@quack.suse.cz>
References: <1266934273-9371-1-git-send-email-akinobu.mita@gmail.com>
 <20100224162152.GK3687@quack.suse.cz>
 <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
 <10f740e81002250050g287f7753g96063376ecee9487@mail.gmail.com>
 <961aa3351002250629p11fc4a49m60aadbf79fc10696@mail.gmail.com>
 <10f740e81002280204q2849317bj3e7d22c5c0c93333@mail.gmail.com>
 <10f740e81002280607p2ec5ec7eya6d6c2cc694b4733@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f740e81002280607p2ec5ec7eya6d6c2cc694b4733@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 28-02-10 15:07:17, Geert Uytterhoeven wrote:
> On Sun, Feb 28, 2010 at 11:04, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, Feb 25, 2010 at 15:29, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >> 2010/2/25 Geert Uytterhoeven <geert@linux-m68k.org>:
> >>> On Thu, Feb 25, 2010 at 02:38, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >>>> 2010/2/25 Jan Kara <jack@suse.cz>:
> >>>>> On Tue 23-02-10 23:11:13, Akinobu Mita wrote:
> >>>>>> Use ext2_find_next_bit (generic_find_next_le_bit) to find the set bit
> >>>>>> in little endian bitmap region.
> >>>
> >>> Is any of this in linux-next now?
> >>>
> >>> http://kisskb.ellerman.id.au/kisskb/buildresult/2208481/
> >>> | fs/udf/balloc.c:274: error: implicit declaration of function
> >>> 'generic_find_next_le_bit'
> >>
> >> Yep, Jan's patch caused the build breakage.
> >>
> >> Because generic_find_next_le_bit() is not available for all
> >> archtectures. So we should use ext2_find_next_bit() here.
> >
> > Most architectures use the definitions in asm-generic, so they're OK.
> > M68k doesn't. S390 is also affected, and I think arm as well (but there's no
> > arm all-modconfig build in linux-next, so I'm not 100% sure).
> >
> > I'm cooking a patch...
> 
> From c9b5c7e6ef2092be822778a0b6b3d3032c058f5b Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Sun, 28 Feb 2010 13:06:27 +0100
> Subject: [PATCH] m68k: Implement generic_find_next_{zero_,}le_bit()
> 
> linux-next:
> fs/udf/balloc.c: In function 'udf_bitmap_new_block':
> fs/udf/balloc.c:274: error: implicit declaration of function
> 'generic_find_next_le_bit'
> 
> Convert ext2_find_next_{zero_,}bit() into generic_find_next_{zero_,}le_bit(),
> and wrap the ext2_find_next_{zero_,}bit() around the latter.
  I've now used Akinobu's patch so yours isn't really needed but it's a
good cleanup anyway in my opinion.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
