Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbXGHSva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbXGHSva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXGHSvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:51:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46576 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbXGHSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:51:22 -0400
Date: Sun, 8 Jul 2007 19:51:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference - git-bisect result
Message-ID: <20070708185118.GL21668@ftp.linux.org.uk>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk> <469121DA.6030600@redhat.com> <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org> <alpine.LFD.0.999.0707081126260.31544@woody.linux-foundation.org> <alpine.LFD.0.999.0707081130420.31544@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707081130420.31544@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 11:38:20AM -0700, Linus Torvalds wrote:
> I do think that it would be even nicer to just have a function that fills 
> in the "struct nameidata" from the dfd. I think we should be able to: the 
> "struct file" really does have the "f_path" thing with both dentry and mnt 
> information, and that would clean up that whole ugly "filepointer-vs-nd" 
> thing a lot.
> 
> That would be an "Al cleanup", though. What do you think, Al?

I think that we need to go the other way round - gather nameidata
->nd and ->dentry into struct path and pass pointer to that instead...

But that's .23-rc1 fodder, if not .23-rc2 one (we might want to
do -rc2 with just that, to avoid conflicts with pending patches).
Definitely not for .22-final.
