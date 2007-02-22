Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXBVLoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXBVLoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXBVLoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:44:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039AbXBVLoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:44:06 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070221163839.b4f5e3b5.akpm@linux-foundation.org> 
References: <20070221163839.b4f5e3b5.akpm@linux-foundation.org>  <20070220195049.26186.69393.stgit@warthog.cambridge.redhat.com> <20070220195106.26186.41931.stgit@warthog.cambridge.redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 4/4] NOMMU: Make it possible for RomFS to use MTD devices directly 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 22 Feb 2007 11:43:00 +0000
Message-ID: <32148.1172144580@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +		brelse(bh);
> 
> A little fyi: brelse() is rather old-fashioned, and has a usually unneeded
> test for non-null bh in it.  In situations where we know that the pointer is 
> valid, let's please use put_bh().

That's what was in the old romfs.  I can make the change, though.

Hmmm... brelse() isn't quite equivalent to put_bh(), but the difference seems
just to be the message you get if you over-release a buffer head - and the
resulting refcount on the BH if that happens.

> Anyway, I'll assume that dwmw2 will be handling this patch series.

I assume so.

David
