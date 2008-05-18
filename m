Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYERPjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYERPjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYERPjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:39:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbYERPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:39:44 -0400
Subject: Re: ext3_dx_add_entry: Directory index full!
From: David Woodhouse <dwmw2@infradead.org>
To: Bernie Innocenti <bernie@codewiz.org>
Cc: lkml <linux-kernel@vger.kernel.org>, ext3-users@redhat.com,
       ext2-devel@lists.sourceforge.net, Stefano Fedrigo <aleph@develer.com>
In-Reply-To: <48304CE2.1090808@codewiz.org>
References: <48304CE2.1090808@codewiz.org>
Content-Type: text/plain
Date: Sun, 18 May 2008 16:39:39 +0100
Message-Id: <1211125179.21380.2.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 17:36 +0200, Bernie Innocenti wrote:
> 
> 
>   static inline unsigned dx_root_limit (struct inode *dir, unsigned
> infosize)
>   {
>       unsigned entry_space = dir->i_sb->s_blocksize -
> EXT3_DIR_REC_LEN(1) -
>           EXT3_DIR_REC_LEN(2) - infosize;
>       return 0? 20: entry_space / sizeof(struct dx_entry);
>   }
> 
> Am I reading the above code correctly?  Why does it always return
> 20 no matter what?

It doesn't. "condition?A:B" will return A if the condition is _true_,
which it isn't.

-- 
dwmw2

