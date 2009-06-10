Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZFJNUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZFJNUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbZFJNTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:19:48 -0400
Received: from thunk.org ([69.25.196.29]:50878 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbZFJNTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:19:43 -0400
Date: Wed, 10 Jun 2009 09:19:09 -0400
From: Theodore Tso <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: next-20090609 hangs in early user mode
Message-ID: <20090610131909.GB6647@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20090610180058.99bd3dda.sfr@canb.auug.org.au> <20090610130054.GR8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610130054.GR8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 02:00:54PM +0100, Al Viro wrote:
> 
> Yes, it's obviously bogus.  Dropped from the tree; I don't think it's
> really salvagable - even merging into one unsigned long will not be
> enough, since we will end up with different locking for different bits.

Oops, sorry, I didn't realize we were using bitops for i_state.  As
far as I can tell we're not using the bitops functions for i_flags,
though.  Is that right?  So we can convert i_flags to be a unsigned
short, but we can't do anything with i_state.

       	      	       		     - Ted
