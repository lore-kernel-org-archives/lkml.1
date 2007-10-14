Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbXJNVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbXJNVU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbXJNVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:20:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:36311 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752591AbXJNVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:20:16 -0400
Date: Sun, 14 Oct 2007 23:14:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove GPL restriction from set_dumpable()
In-Reply-To: <20071014210341.GA30029@infradead.org>
Message-ID: <Pine.LNX.4.64.0710142311150.20620@jikos.suse.cz>
References: <Pine.LNX.4.64.0710141257030.20620@jikos.suse.cz>
 <20071014210341.GA30029@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007, Christoph Hellwig wrote:

> > Commit 6c5d5238 introduced a set_dumpable() function that replaced the 
> > direct access to mm_struct->dumpable. I don't think there is any 
> > reason to restrict this function to EXPORT_SYMBOL_GPL() -- previously 
> > any module could modify current->mm->dumpable without any 
> > resitrictions, so it makes a little sense to turn this into 'internal 
> > interface' at once.
> Nack, the just shouldn't do such things at all.  I start to get really 
> sick of patches adding random exports everywhere.

I actually don't care that much whether this is merged or not. In fact the 
function itself is pretty trivial and standalone, so any 3rd party module 
willing to modify current->mm->flags can just reimplement it line-by-line 
themselves without breaking the license anyway ...

My main point here was that we should probably better document somewhere 
what are the intended usage scenarios for EXPORT_SYMBOL() vs. 
EXPORT_SYMBOL_GPL(). "Really internal interface" seems a little bit vague 
to me.

-- 
Jiri Kosina
SUSE Labs
