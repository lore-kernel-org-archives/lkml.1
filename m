Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbXBDRtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbXBDRtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXBDRtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:49:32 -0500
Received: from lazybastard.de ([212.112.238.170]:37417 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXBDRtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:49:31 -0500
Date: Sun, 4 Feb 2007 17:45:57 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] Pack the vfsmount and dentry in nameidata into a struct path
Message-ID: <20070204174557.GA5468@lazybastard.org>
References: <200702031425.38054.agruen@suse.de> <20070204041653.GA3672@lazybastard.org> <200702040400.51958.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702040400.51958.agruen@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 February 2007 04:00:51 -0800, Andreas Gruenbacher wrote:
> On Saturday 03 February 2007 20:16, Jörn Engel wrote:
> > On its own, I don't like this patch too much.  It is just a form of
> > mental masturbation that complicates the source.
> 
> Thanks for pointing out the masturbation thing. I was actually polling for 
> comments; this single patch in itself wasn't meant to be the ultimate hot 
> stuff.

Yes, my wording wasn't too diplomatic - again.  Some day I might learn.
What I should have said is something like: The patch has no merits of
its own.  Its usefullness depends completely on the follow-up patches.

> > > -	inode = nd.dentry->d_inode;
> > > +	inode = nd.path.dentry->d_inode;
> >
> > However, once we start passing struct path by reference, it should
> > result in a smaller binary.
> 
> There are several components to it. Storing the dentry and vfsmount in a 
> struct path allows to pass them somewhere where a struct path is expected 
> without having to construct a temporary struct path object. Also, two 
> parameters would become one; I believe that this could lead to somewhat 
> cleaner code in some places.

Some time ago I stopped believing in "cleaner" code.  If any given patch
has no merits besides being cleaner, in most cases it is just changing
the code to the personal taste of whoever is sending the patch.

In this concrete case, your current patch is full of replacements that
make the code longer and doesn't seem to add much else.  In my personal
opinion that makes the code less clean.  The number of parameters for
some functions could be reduced, if calling by value, but overall it is
just a large amount of churn without any real benefit.

Call-by-reference may be a completely different story.  If that turns
out to reduce binary size, we are well beyond personal taste and
masturbation.

> The other question is whether we would want to pass such struct paths by value 
> or by reference: by value would lead to roughly the same code that we have 
> right now. By reference would reduce the function call overhead, but would 
> blow up the code that accesses the struct path elements by about the same 
> amount: getting to the dentry or vfsmount from a struct path pointer requires 
> a pointer dereference.
> 
> It's hard to tell whether the code size would decrease overall with 
> by-reference passing. The experiments I did didn't, but I also didn't try to 
> optimize the by-reference code.

Hmm.  This doesn't confirm my hope of size reduction.  It was a nice
idea and definitely worth investigating.  Thank you for doing it and
sorry for experiencing my unique charm.

Jörn

-- 
Unless something dramatically changes, by 2015 we'll be largely
wondering what all the fuss surrounding Linux was really about.
-- Rob Enderle
