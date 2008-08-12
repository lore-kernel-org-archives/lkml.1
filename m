Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbYHLSWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbYHLSWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYHLSWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:22:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54594 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYHLSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:22:44 -0400
Date: Tue, 12 Aug 2008 19:22:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812182240.GS28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812181057.GR28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 07:10:57PM +0100, Al Viro wrote:
> There's one more thing in that mess: a bunch of vfs_readdir() callers
> end up playing very sick games to make sure they get the entire
> directory.  The trick is to find whether the damn thing has reached
> the end; as it is, there are instances of ->readdir() that do _not_
> (e.g. call filldir only once and let the caller repeat).
> 
> I'm certainly not too fond of buf->error.  If you see a better interface
> I'd love to hear about it, but I don't think that "just return anything
> non-zero we'd got from callback" is going to be good.  And if we go for
> flagday changes in ->readdir(), we'd better get it right...

PS: we might get away with both, if we used _positive_ values as well.
E.g. have getdents() filldir return 1 if we are out of buffer *and*
have ->previous != NULL (and -EINVAL if we are out of buffer on the
first call)...  And have some other positive constant for "->readdir()
didn't feel like going all the way to the end of directory".
