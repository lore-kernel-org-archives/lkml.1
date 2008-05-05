Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYEEPfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYEEPfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYEEPfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:35:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57867 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYEEPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:35:03 -0400
Date: Mon, 5 May 2008 16:35:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Enrico Weigelt <weigelt@metux.de>
Cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505153501.GN5882@ZenIV.linux.org.uk>
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505134315.GF32019@nibiru.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 03:43:15PM +0200, Enrico Weigelt wrote:
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > That you have quite forgotten about mounts.  
> 
> hmm, I though this would be done before the link_path_walk() 
> call happens ;-o

How on the earth...?  You don't know where will pathname resolution
get you, so how could you possibly handle mountpoint transitions prior
to it?

> And if you use that option, you'll simply loose the ability
> of using mointpoints within this specific mount. This won't 
> affect any situation other than #1 && #2, IMHO this is better
> than no chance of fast lookups at all. Of course, an cleaner
> approach would be better, but it's IMHO not critical.

This is crap.  First of all, the logics is already overcomplicated.
_Then_ we have a problem of populating dcache for intermediates.

Besides, that's not what that thing is for - it's to allow local
caching (which we do) with revalidation of several components
at once.  _After_ VFS has decided that nothing interesting is in
the part of path it has cached.  Then the protocol allows to do
bulk Walk, verifying that all cached intermediates still match
the reality, all in one roundtrip.
