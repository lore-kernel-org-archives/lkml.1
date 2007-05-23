Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbXEWNDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbXEWNDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXEWNDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:03:15 -0400
Received: from lazybastard.de ([212.112.238.170]:41511 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbXEWNDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:03:13 -0400
Date: Wed, 23 May 2007 14:58:41 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: Review status (Re: [PATCH] LogFS take three)
Message-ID: <20070523125840.GC24738@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515152149.GB32059@lazybastard.org> <20070517160308.GA26643@2ka.mipt.ru> <20070517171017.GB15676@lazybastard.org> <20070520173049.GA20907@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070520173049.GA20907@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 21:30:52 +0400, Evgeniy Polyakov wrote:
> 
> In that case segment size must be more than 32 bits, or below
> transformation will not be correct?

Must it?  If segment size is just 20bit then the filesystem may only be
52bit.  Or 51bit when using signed values.

> segsize is long, but should be u64 I think.

It could be s32 as well.

> static void fixup_from_wbuf(struct super_block *sb, struct logfs_area
> 	*area, void *read, u64 ofs, size_t readlen)
> 
> u32 read_start = ofs & (super->s_segsize - 1);
> u32 read_end = read_start + readlen;
> 
> And this can overflow, since readlen is size_t.

Theoretically yes.  Practically readlen is bounded to sb->blocksize plus
one header.  I'll start worrying about that when blocksize approaches
32bit limit.

> > If anyone can find similar bugs, the bounty is a beer or non-alcoholic
> > beverage of choice. :)
> 
> Stop kiling your kidneys, your health and promote such antisocial style
> of life, start drinking vodka instead.

I'm just a German.  Forgive me if I drink lesser beverages.

Jörn

-- 
Eighty percent of success is showing up.
-- Woody Allen
