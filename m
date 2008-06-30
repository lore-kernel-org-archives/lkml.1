Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbYF3NJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbYF3NJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYF3NJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:09:12 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:64854 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbYF3NJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:09:11 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking 
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       mhalcrow@us.ibm.com, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806301238080.6538@blonde.site>
References: <Pine.LNX.4.64.0806290101160.20280@blonde.site> <8725.1214800317@jrobl> <Pine.LNX.4.64.0806301238080.6538@blonde.site>
Date: Mon, 30 Jun 2008 22:08:12 +0900
Message-ID: <7439.1214831292@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hugh Dickins:
> It certainly shouldn't be.  The problem would have come from two
> racing i_size_write(dst)s, one of the unlocked increments getting
> lost, leaving seqcount odd, so the next i_size_read(dst) would
> spin forever waiting for it to go even.

I see.
The unlocked increment can cause the next i_size_read() hang.


> I'm not sure what you mean by that.  i_size_read() doesn't fail,
> but it may loop; and if the seqcount has got out of step from
> concurrent unlocked i_size_write()s, then it'll spin forever.

What I meant by "fail" was "loop" actually.
And I understand that you didn't writing directly (bypassing unionfs)
too.


Junjiro Okajima
