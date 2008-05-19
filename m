Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYESGeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYESGeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbYESGd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:33:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60665 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbYESGd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:33:58 -0400
Date: Mon, 19 May 2008 07:33:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/6] ERR_PTR: add ERR_OR_0_PTR
Message-ID: <20080519063355.GA13907@ZenIV.linux.org.uk>
References: <20080513201813.GA5869@joi> <1211148067-16130-1-git-send-email-marcin.slusarz@gmail.com> <20080519055504.GB14902@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519055504.GB14902@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 07:55:04AM +0200, Christoph Hellwig wrote:
> On Mon, May 19, 2008 at 12:01:07AM +0200, Marcin Slusarz wrote:
> > Some codepaths call ERR_PTR with possibly 0 argument, which is not
> > a valid errno and rely on conversion from 0 to NULL pointer.
> > Add ERR_OR_0_PTR function which accepts errnos and 0 as an argument.
> 
> Sorry, no.  ERR_PTR(0) is perfectly valid, you just don't want to return
> the actualy value.  E.g. we have a common idiom of:
> 
> 	some_ptr = ERR_PTR(err);
> 	if (IS_ERR(some_ptr))
> 		goto out_handle_err;
> 
> and obsfucating this with new syntactic sugar is not a good idea.

Um... Could somebody explain WTF is wrong with declaring that ERR_PTR(0)
is NULL?  Sure, if we run into a target where converting non-constant
integer with value zero to void * does not result in null pointer, we'll
need to adjust ERR_PTR().  So.  Fscking.  What?
	a) it's not a lot of adjustment, to start with
	b) any such target will require much more work on porting anyway;
this part will be trivial.
