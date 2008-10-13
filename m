Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYJMO3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYJMO3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYJMO2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:28:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47883 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbYJMO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:28:51 -0400
To: cl@linux-foundation.org
CC: miklos@szeredi.hu, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org
In-reply-to: <48F3765A.2010301@linux-foundation.org> (message from Christoph
	Lameter on Mon, 13 Oct 2008 09:24:58 -0700)
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu> <48F3765A.2010301@linux-foundation.org>
Message-Id: <E1KpOPb-0003Wd-AZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 13 Oct 2008 16:28:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Christoph Lameter wrote:
> Miklos Szeredi wrote:
> > I think it's wrong to unhash dentries while they are possibly still
> > being used.  You can do the shrink_dcache_parent() here, but should
> > leave the unhashing to be done by prune_one_dentry(), after it's been
> > checked that there are no other users of the dentry.
> >
> >   
> d_invalidate() calls shrink_dcache_parent() as needed and will fail if 
> there are other users of the dentry.

Only if it's a directory.  Now unhashing an in-use non-directory is
not fatal, but you'll get things like "filename (deleted)" in /proc,
and suchlike.  Don't do it.

Miklos
