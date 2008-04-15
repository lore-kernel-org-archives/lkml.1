Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYDOX5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYDOX5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYDOX5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:57:13 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:51902 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYDOX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:57:11 -0400
Date: Tue, 15 Apr 2008 19:56:59 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] omfs: add inode routines
Message-ID: <20080415235659.GA7068@hash.localnet>
References: <1208041121-26787-3-git-send-email-me@bobcopeland.com> <20080415183054.GA7176@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415183054.GA7176@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 08:30:59PM +0200, Marcin Slusarz wrote:
> > +	if (be32_to_cpu(omfs_sb->s_magic) != OMFS_MAGIC) {
> 
> can be omfs_sb->s_magic != cpu_to_be32(OMFS_MAGIC)
> (cpu_to_be32 can be optimized away even on LE)

Good point, I'll change that.

> > +	if (bh)
> > +		brelse(bh);
> brelse(NULL) is safe to call

Yup, I saw that too.  I dropped these and added the labels per Miklos'
suggestion.

> > +	return ret;
> > +}
> 
> this code leaks omfs_sbi_info (sbi)

This one I'm not seeing.  FS core calls put_super if ret is nonzero so
this should be ok?

Thanks!
-- 
Bob Copeland %% www.bobcopeland.com 

