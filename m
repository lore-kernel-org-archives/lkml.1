Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbZFJNBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbZFJNBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZFJNAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:00:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZFJNAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:00:54 -0400
Date: Wed, 10 Jun 2009 14:00:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: next-20090609 hangs in early user mode
Message-ID: <20090610130054.GR8633@ZenIV.linux.org.uk>
References: <20090610180058.99bd3dda.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610180058.99bd3dda.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 06:00:58PM +1000, Stephen Rothwell wrote:

> d4fdcb2068eef29c03d6027aa219fa60171c6b87 is first bad commit
> commit d4fdcb2068eef29c03d6027aa219fa60171c6b87
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu May 21 16:00:59 2009 -0400
> 
>     fs: i_flags and i_state in struct inode only need to be unsigned short
>     
>     Currently i_flags and i_state do not need to be an unsigned int and an
>     unsigned long, respectively.  (We currently use 9 i_flags bits, and 8
>     i_state bits.)  Changing them to be an unsigned short saves 4 bytes
>     per inode on an x86 platform, and 8 bytes on an x86_64 platform.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>     Cc: linux-fsdevel@vger.kernel.org
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

*gyah*

Yes, it's obviously bogus.  Dropped from the tree; I don't think it's
really salvagable - even merging into one unsigned long will not be
enough, since we will end up with different locking for different bits.
