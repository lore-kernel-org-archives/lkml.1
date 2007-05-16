Return-Path: <linux-kernel-owner+w=401wt.eu-S1763042AbXEPRjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763042AbXEPRjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbXEPRiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:38:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbXEPRix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:38:53 -0400
Date: Wed, 16 May 2007 19:38:52 +0200
From: Jan Kara <jack@suse.cz>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070516173852.GC29602@atrey.karlin.mff.cuni.cz>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070511110920.GA11898@cvg> <20070513210126.GB14030@infradead.org> <20070516143308.GA8327@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516143308.GA8327@cvg>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [Christoph Hellwig - Sun, May 13, 2007 at 10:01:26PM +0100]
> | On Fri, May 11, 2007 at 03:09:20PM +0400, Cyrill Gorcunov wrote:
> | > | > | And please get rid of the UDF_I_* macro for everything you touch, just
> | > | > | put a
> | > | > | 
> | > | > | 	struct udf_inode_info *uip = UDF_I(inode);
> | > | > | 
> | > | > | at the beginning of the function and use the fields directly.
> | > | > | 
> | > | > 
> | > | > Actually to properly remove UDF_I* and UDF_SB_* macroses in the
> | > | > whole UDF subsystem - is _lot_ of work. I'm going to make it but
> | > | > not now (too busy).
> | > | 
> | > | Doing it completely is a lot of work, yes.  I was more thinking of
> | > | converting a piece of code once you do major changes.  But if you
> | > | want to convert all the code as a separate patch I'm more than happy
> | > | aswell.
> | > | 
> | > 
> | > Christoph, my only argue against getting rid of UDF_I_* macro in
> | > my patch is UDF coding style, I don't want to damage it. I think
> | > we may leave it as is (including my patch). So just review the patch
> | > I sent (second version) and Ack it then so Andrew could include it
> | > into mm tree. Meantime I'm rewritting the whole UDF subsystem to
> | > get rid of that macroses (it will be a long way ;)
> | 
> | The UDF style is horrible and very unlike other kernel code.  Given
> | that udf has been pretty much unmtained for a while there should be
> | nothing in the way of fixing it.
> | 
> | Anyway, the patch is technically correct so you'll get my ACK (not
> | that you should need it).
> | 
> 
> you know I've read UDF sources. As I understand all UDF_I_ macroses
> could be converted without breaking UDF state but... as you exactly
> mentoined it's style is horrible and I'm thinking about rewritting the
> whole UDF system. Unfortunelly I'm not _mature_ kernel developer (I'm kernel
> newbie) and it could take a long time for this (I think something like
> ~ 3 month or more ;). Actually I'm ready to spend my free time for
> this. So how do you think could it be reasonable?
  I've spent some time hunting bugs in UDF recently so I'll warn you a
bit :). Definitely rewriting that ... code would be a good thing to do
(reading that code I had urges to do it several times). The hard thing
is that there is no reasonable spec you could use - there are two
documents which define how UDF should look like but they are really hard
to read (they have like hundred pages each and one does not make sence
without the other). And reading the code and learning how the filesystem is
supposed to work isn't too helpful either. Just a friendly warning ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
