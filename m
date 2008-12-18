Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752266AbYLRNkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbYLRNkr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYLRNki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:40:38 -0500
Received: from brick.kernel.dk ([93.163.65.50]:20007 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYLRNkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:40:37 -0500
Date: Thu, 18 Dec 2008 14:40:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Fabio Checconi <fabio@gandalf.sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: Dynamic switching of io_context
Message-ID: <20081218134006.GP32491@kernel.dk>
References: <4942B90F.6050807@vlnb.net> <20081216082235.GD3284@gandalf.sssup.it> <49494A50.3090201@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49494A50.3090201@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17 2008, Vladislav Bolkhovitin wrote:
> >I haven't seen the rest of the code, so I may be wrong, but I suppose
> >that a better approach would be to use CLONE_IO to share io contexts,
> >if possible.
> 
> Unfortunately, it would be very non-optimal. As it is known, to achieve 
> the best performance with async. IO, it should be submitted by a limited 
> number of threads <= CPU count. So, the only way to submit IO from each 
> of, e.g. 100, clients in a dedicated per-client IO context is to 
> dynamically switch io_context of the current threads to io_context of 
> the client before IO submission.

There's also likely to be another use of exactly the same type of thing
- the acall patches from Zach. At least my vision of the punt-to-thread
approach would be very similar: grab an available thread and attach it
to a given IO context.

So while I did mention exactly what Fabio outlines in my initial mail on
this, a generic way to attach/detach IO contexts from processes/threads
would be useful outside of this project. nfsd comes to mind as well.

-- 
Jens Axboe

