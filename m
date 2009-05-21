Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZEUU2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZEUU2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbZEUU2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:28:46 -0400
Received: from thunk.org ([69.25.196.29]:42787 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbZEUU2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:28:46 -0400
Date: Thu, 21 May 2009 16:28:40 -0400
From: Theodore Tso <tytso@mit.edu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/5] Dump the inode structure (for debugging purposes
	only)
Message-ID: <20090521202840.GB9236@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1242936063-31689-1-git-send-email-tytso@mit.edu> <1242936063-31689-2-git-send-email-tytso@mit.edu> <1242936063-31689-3-git-send-email-tytso@mit.edu> <1242936063-31689-4-git-send-email-tytso@mit.edu> <1242936063-31689-5-git-send-email-tytso@mit.edu> <1242936063-31689-6-git-send-email-tytso@mit.edu> <20090521200942.GA5110@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521200942.GA5110@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 02:09:42PM -0600, Matthew Wilcox wrote:
> On Thu, May 21, 2009 at 04:01:03PM -0400, Theodore Ts'o wrote:
> > This is not intended for merging; but it's useful for determining how
> > much varous fields in the struct inode space, and whether there is any
> > padding leading to waste, especially on a 64-bit platforms.
> 
> Why not just use acme's pahole?
> 

Because I didn't know about it, and now that I've looked at it, it
requires compiling the kernel with CONFIG_DEBUG_INFO, which means the
kernel takes a lot longer to build.  What I did is a bit more hackish,
to be sure, but it's faster to drop it into the tree and then run it
under kvm and then pull it out of the console logs.  If you were
planning on investigating a large number of structures, acme's
solution probably is a better one; but if you only need one, it might
be faster to whip up a custom kernel module, perhaps built out of the
tree, instead of rebuilding the entire kernel with CONFIG_DEBUG_INFO.

      	      	 	    	       	      - Ted
