Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab0CAKv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:51:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:51748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0CAKv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:51:57 -0500
Date: Mon, 1 Mar 2010 11:52:08 +0100
From: Jan Kara <jack@suse.cz>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: use ext2_find_next_bit
Message-ID: <20100301105208.GB3271@quack.suse.cz>
References: <1266934273-9371-1-git-send-email-akinobu.mita@gmail.com>
 <20100224162152.GK3687@quack.suse.cz>
 <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-02-10 10:38:25, Akinobu Mita wrote:
> 2010/2/25 Jan Kara <jack@suse.cz>:
> > On Tue 23-02-10 23:11:13, Akinobu Mita wrote:
> >> Use ext2_find_next_bit (generic_find_next_le_bit) to find the set bit
> >> in little endian bitmap region.
> >>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> Cc: Jan Kara <jack@suse.cz>
> >  I've looked at the code and I think this is wrong. UDF uses 1 for free
> > block in the bitmap and 0 for used one. So you need to use
> > generic_find_next_le_bit...
> >  Something like the patch below?
> 
> According to include/asm-generic/bitops/ext2-non-atomic.h,
> generic_find_next_le_bit() == ext2_find_next_bit().
  Ah, I'm really sorry. I've originally misread the header and thought that
ext2_find_next_bit == generic_find_next_le_zero_bit. So my patch does
exactly the same thing as yours. I've now merged your patch so that you get
proper credit.

> BTW, I realized that udf_find_first_one_bit() macro is not used.
> So you can remove it in this patch.
  Yes, I've removed it now.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
