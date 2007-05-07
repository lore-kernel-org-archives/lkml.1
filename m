Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXEGPud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXEGPud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934414AbXEGPu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:50:29 -0400
Received: from THUNK.ORG ([69.25.196.29]:39323 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934412AbXEGPu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:50:28 -0400
Date: Mon, 7 May 2007 11:50:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: david@lang.hm
Cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Message-ID: <20070507155021.GD17180@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
	Frank van Maarseveen <frankvm@frankvm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20070506222626.GA25632@janus> <20070507142736.GC17180@thunk.org> <Pine.LNX.4.64.0705070744350.18013@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705070744350.18013@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 07:46:38AM -0700, david@lang.hm wrote:
> On Mon, 7 May 2007, Theodore Tso wrote:
> 
> >We're going to have to rethink the defaults of the journal size as it
> >relates to on-line resizing, but there might not be a lot of great
> >answers here.  We'll also have to look at the on-line resizing code
> >and see if there's a way to break up the resize operation into smaller
> >transactions as a way of avoiding this problem --- but that would
> >still leave the user stuck with a pathetically small 4M journal on a
> >3G filesystem.
> 
> why not just allocate a new journal (something along the lines of convert 
> the ext3 to ext2 then back to ext3 would be the ugly, scripted way of 
> doing it)
> 
> or is the problem that you are trying to resize things without remounting 
> them (and therefor without flushing the journal)

Yes, I'm referring to the difficulties of getting this right when
doing online (mounted) resizing, as that was the context of the
original bug report.

Clearly the right thing for resize2fs to do when it's doing an
off-line resize is to just adjust the journal inode and make it
bigger.  I'll add that to my todo list, but of course, patches to do
that would be gratefully accepted...

						- Ted
