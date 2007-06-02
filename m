Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbXFBUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbXFBUDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbXFBUDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 16:03:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:54893 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXFBUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 16:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mUA7xmoJR57uP09oukWgVqvYElwSM6QhWKV7EtKYrPborILfL0eKo1S0qnyg63ptPwyhHISIXLx1sP21cUqRHWlfM+SlJ0H6O5V3ZTbM8kJAHs8rTA430ktFWp2gXEV3lVbCnXyrUOzD74oFniuQLmiY0GouKtzbjHkXNofmkuU=
Date: Sun, 3 Jun 2007 00:01:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Eric Sandeen <sandeen@sandeen.net>,
       Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070602200146.GC8518@cvg>
References: <4660FD7F.4090302@sandeen.net> <20070601224339.c803e04e.akpm@linux-foundation.org> <20070602063403.GA8387@cvg> <20070601235422.fdc1f750.akpm@linux-foundation.org> <20070602065923.GB8387@cvg> <20070602000645.508ddf93.akpm@linux-foundation.org> <20070602140619.GA10303@cvg> <20070602103203.e39d25ed.akpm@linux-foundation.org> <20070602185707.GA8518@cvg> <20070602121616.37ffce9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602121616.37ffce9e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Sat, Jun 02, 2007 at 12:16:16PM -0700]
[...snip...]
| 
| No, the problem is that the patch caused the kernel to take inode_lock
| within the newly-added drop_inode(), btu drop_inode() is already called
| under inode_lock.
| 
| It has nothing to do with lock_kernel() and it has nothing to do with
| sleeping.
| 

Andrew, the only call that could leading to subseq. inode_lock lock
is mark_inode_dirty() I guess (and that is snown by Eric's dump)
but as I shown you in my dbg print without SMP it's OK. So
is it SMP who lead to lock? How it depends on it? (I understand
that is a stupid question for you but if you have time explain
me this please ;)

		Cyrill

