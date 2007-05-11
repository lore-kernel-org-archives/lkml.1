Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbXEKSjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbXEKSjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXEKSja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:39:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757865AbXEKSj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:39:29 -0400
Date: Fri, 11 May 2007 11:39:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [patch 1/2] From: Paul Mundt <lethal@linux-sh.org>
Message-Id: <20070511113915.267bcc66.akpm@linux-foundation.org>
In-Reply-To: <20070511165945.913632068@sgi.com>
References: <20070511165749.026947116@sgi.com>
	<20070511165945.913632068@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 09:57:50 -0700
clameter@sgi.com wrote:

> > I'll take a look at tidying up the PMB slab, getting rid of the dtor
> > shouldn't be terribly painful. I simply opted to do the list management
> > there since others were doing it for the PGD slab cache at the time that
> > was written.
> 
> And here's the bit for dropping pmb_cache_dtor(), moving the list
> management up to pmb_alloc() and pmb_free().
> 
> With this applied, we're all set for killing off slab destructors
> from the kernel entirely.

hm, this is already in Paul's git tree.

If we're going to slam all this into 2.6.22 then I can just tempdrop Paul's
tree.

However I think we've done enough slab work for 2.6.22 now so I'm inclined
to queue these changes for 2.6.23.  That would mean that the slab changes in
-mm have a dependency on the sh git tree which I am sure to forget about.
If I end up merging these changes before Paul merges his tree, sh will
break.  Presumably Paul will notice this ;)
