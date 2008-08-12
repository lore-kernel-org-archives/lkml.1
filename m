Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYHLUiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYHLUiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYHLUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:38:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYHLUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:38:11 -0400
Date: Tue, 12 Aug 2008 21:38:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812203808.GV28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 01:21:56PM -0700, Linus Torvalds wrote:
> We *must* handle partial returns by returning "success". And we do, 
> except for our _confusion_ about ->readdir() returning error and that 
> somehow "overriding" the fact that it already returned non-errors earlier 
> through the callback.
> 
> All your blathering about "positive values as well" seems to ttoally 
> misunderstand how readdir() works. We absolutely do *not* need positive 
> return values, because the fact is, the only positive return value we ever 
> need is the "we already filled _earlier_ buffers". And that's the one 
> that we already do.
> 
> The fact is, NO ERROR VALUE CAN POSSIBLY MATTER if we already returned one 
> or more entries to getdents/readdir(). We should return a success value.

	Would you care to grep for vfs_readdir() in the tree?  It's not just
sys_getdents(); for better of worse the thing had become a general-purpose
iterator.  And I'm not suggesting to pass the damn thing to caller of
sys_getdents().  At all.
