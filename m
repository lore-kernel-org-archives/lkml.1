Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbXENUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbXENUDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXENUDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:03:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:54537 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbXENUDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:03:21 -0400
Date: Mon, 14 May 2007 14:06:19 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] resolve duplicate flag no for PG_lazyfree
Message-ID: <20070514180618.GB9399@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fengguang Wu <fengguang.wu@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <379110250.28666@ustc.edu.cn> <20070513224630.3cd0cb54.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513224630.3cd0cb54.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 10:46:30PM -0700, Andrew Morton wrote:
> otoh, the intersection between pages which are PageBooked() and pages which
> are PageLazyFree() should be zreo, so it'd be good to actually formalise
> this reuse within the ext4 patches.
> 
> otoh2, PageLazyFree() could have reused PG_owner_priv_1.
> 
> Rik, Ted: any thoughts?  We do need to scrimp on page flags: when we
> finally run out, we're screwed.

It makes sense to me.  PG_lazyfree is currently only in -mm, right?  I
don't see it in my git tree.  It would probably would be a good idea
to make sure that we check to add some sanity checking code if it
isn't there already that PG_lazyfree isn't already set when try to set
PG_lazyfree (just in case there is a bug in the future which causes
the should-never-happen case of trying lazy free a PageBooked page).

						- Ted
