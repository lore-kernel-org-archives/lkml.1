Return-Path: <linux-kernel-owner+w=401wt.eu-S935270AbXEWPTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935270AbXEWPTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbXEWPSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:18:49 -0400
Received: from lazybastard.de ([212.112.238.170]:36855 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935072AbXEWPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:18:47 -0400
Date: Wed, 23 May 2007 17:14:04 +0200
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
Message-ID: <20070523151402.GA25532@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515152149.GB32059@lazybastard.org> <20070517160308.GA26643@2ka.mipt.ru> <20070517171017.GB15676@lazybastard.org> <20070520173049.GA20907@2ka.mipt.ru> <20070523125840.GC24738@lazybastard.org> <20070523150732.GA2456@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070523150732.GA2456@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 19:07:32 +0400, Evgeniy Polyakov wrote:
> On Wed, May 23, 2007 at 02:58:41PM +0200, Jörn Engel (joern@lazybastard.org) wrote:
> > On Sun, 20 May 2007 21:30:52 +0400, Evgeniy Polyakov wrote:
> 
> And what if it is 33 bits? Or it is not allowed?

Not allowed.  Both number and size of segments may never exceed 32bit.

> > > segsize is long, but should be u64 I think.
> > 
> > It could be s32 as well.
> 
> It is a matter of definition - if segment size is allowed to be more
> than 32 bits, then below transformation is not correct, otherwise
> segment size should not use additional 32bits on 64bit platform, since
> it is long.

I guess I could save 4 Bytes there.

> > I'm just a German.  Forgive me if I drink lesser beverages.
> 
> You should definitely change that.

Change being German?  Not a bad idea, actually.

> Btw, what about this piece:
> 
> int logfs_erase_segment(struct super_block *sb, u32 index)
> {
> 	struct logfs_super *super = LOGFS_SUPER(sb);
> 
> 	super->s_gec++;
> 
> 	return mtderase(sb, index << super->s_segshift, super->s_segsize);
> }
> 
> index << super->s_segshift might overflow, mtderase expects loff_t
> there, since index can be arbitrary segment number, is it possible, that
> overflow really occurs?

Indeed it is.  You just earned your second beer^Wvodka.

Jörn

-- 
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
