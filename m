Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYBRPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYBRPQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYBRPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:16:41 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39637 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753518AbYBRPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:16:40 -0500
Date: Mon, 18 Feb 2008 10:16:32 -0500
From: Theodore Tso <tytso@mit.edu>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080218151632.GD25098@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Andi Kleen <andi@firstfloor.org>,
	LKML <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B99E0C.8020706@wpkg.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:02:36PM +0100, Tomasz Chmielewski wrote:
> I tried to copy that filesystem once (when it was much smaller) with "rsync 
> -a -H", but after 3 days, rsync was still building an index and didn't copy 
> any file.

If you're going to copy the whole filesystem don't use rsync!  Use cp
or a tar pipeline to move the files.

> Also, as files/hardlinks come and go, it would degrade again.

Yes...

> Are there better choices than ext3 for a filesystem with lots of hardlinks? 
> ext4, once it's ready? xfs?

All filesystems are going to have problems keeping inodes close to
directories when you have huge numbers of hard links.

I'd really need to know exactly what kind of operations you were
trying to do that were causing problems before I could say for sure.
Yes, you said you were removing unneeded files, but how were you doing
it?  With rm -r of old hard-linked directories?  How big are the
average files involved?  Etc.

					- Ted
