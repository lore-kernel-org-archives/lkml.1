Return-Path: <linux-kernel-owner+w=401wt.eu-S1751339AbZFUMe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbZFUMe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZFUMeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:34:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:32784 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZFUMeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:34:18 -0400
Date: Sun, 21 Jun 2009 21:34:09 +0900 (JST)
Message-Id: <20090621.213409.32665554.ryusuke@osrg.net>
To: users@nilfs.org, andi@firstfloor.org
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [NILFS users] [PATCH] nilfs2: fix hang problem after
 bio_alloc() failed
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <87ocshvo78.fsf@basil.nowhere.org>
References: <20090614181313.GA16597@homero.springfield.home>
	<20090619.023455.111674749.ryusuke@osrg.net>
	<87ocshvo78.fsf@basil.nowhere.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 21 Jun 2009 21:34:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,
On Sun, 21 Jun 2009 13:08:43 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> writes:
> >  
> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > index 22c7f65..e8f188b 100644
> > --- a/fs/nilfs2/segment.c
> > +++ b/fs/nilfs2/segment.c
> > @@ -1846,26 +1846,13 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
> >  		err = nilfs_segbuf_write(segbuf, &wi);
> >  
> >  		res = nilfs_segbuf_wait(segbuf, &wi);
> > -		err = unlikely(err) ? : res;
> > +		err = unlikely(err) ? err : res;
> 
> It's very dubious gcc does anything with unlikely here anyways.
> They typically only work directly in conditions being tested.

I got it. I'll rewrite the first bugfix so that it just removes the
unlikely directive.

-		err = unlikely(err) ? : res;
+		err = err ? : res;


> >  		if (unlikely(err))
> >  			return err;
> 
> Also gcc generally considers conditions to blocks that
> return unlikely, so it's actually superfluous.

Thanks, I didn't know this.  I'll take in this, too.
 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.

Regards,
Ryusuke Konishi
