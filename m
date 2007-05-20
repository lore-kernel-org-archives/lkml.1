Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbXETRdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbXETRdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbXETRcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:32:55 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43405 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362AbXETRcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:32:53 -0400
Date: Sun, 20 May 2007 21:30:52 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: Review status (Re: [PATCH] LogFS take three)
Message-ID: <20070520173049.GA20907@2ka.mipt.ru>
References: <20070515151919.GA32510@lazybastard.org> <20070515152149.GB32059@lazybastard.org> <20070517160308.GA26643@2ka.mipt.ru> <20070517171017.GB15676@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070517171017.GB15676@lazybastard.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 20 May 2007 21:31:04 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 07:10:19PM +0200, Jörn Engel (joern@lazybastard.org) wrote:
> On Thu, 17 May 2007 20:03:11 +0400, Evgeniy Polyakov wrote:
> > 
> > Is logfs 32bit fs or 674bit, since although you use 64bit values for
> > offsets, area management and strange converstions like described below 
> > from offset into segment number are performed in 32bit?
> > Is it enough for SSD for example to be 32bit only? Or if it is 64bit,
> > could you please explain logic behind area management?
> 
> Ignoring bugs and signed return values for error handling, it is either
> 64bit or 32+32bit.
> 
> Inode numbers and file positions are 64bit.  Offsets are 64bit as well.
> In a couple of places, offsets are also 32+32bit.  Basically the high
> bits contain the segment number, the lower bits the offset within a
> segment.

In that case segment size must be more than 32 bits, or below
transformation will not be correct? segsize is long, but should be u64 I
think.

static void fixup_from_wbuf(struct super_block *sb, struct logfs_area
	*area, void *read, u64 ofs, size_t readlen)

u32 read_start = ofs & (super->s_segsize - 1);
u32 read_end = read_start + readlen;

And this can overflow, since readlen is size_t.
It is wbuf fixup, but I saw that somewhere else.
Although, according to your description, it should be 32bit, sum can be
more than 32 bit.

> If anyone can find similar bugs, the bounty is a beer or non-alcoholic
> beverage of choice. :)

Stop kiling your kidneys, your health and promote such antisocial style
of life, start drinking vodka instead.

> Jörn

-- 
	Evgeniy Polyakov
