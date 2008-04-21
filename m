Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYDUAnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYDUAnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYDUAmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:42:49 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35876 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYDUAms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:42:48 -0400
Date: Sun, 20 Apr 2008 20:41:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/8] omfs: add inode routines
Message-ID: <20080421004148.GA7454@hash.localnet>
References: <1208637457-24969-4-git-send-email-me@bobcopeland.com> <20080419212842.GA7888@joi> <20080420095718.GA6079@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420095718.GA6079@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 11:57:22AM +0200, Marcin Slusarz wrote:
> > > +static void set_block_shift(struct omfs_sb_info *sbi)
> > > +{
> > > +	unsigned int scale = sbi->s_blocksize / sbi->s_sys_blocksize;
[...]
> > isn't it get_bitmask_order(scale - 1)?
> 
> I mean get_bitmask_order(scale >> 1) ;)

Thank you for your comments.  Hmm, yeah I think so.  It could also
lose the divide:

  scale = get_bitmask_order(sbi->s_blocksize) -
          get_bitmask_order(sbi->s_sys_blocksize);

(or ffs/fls for that matter.)

-- 
Bob Copeland %% www.bobcopeland.com 

