Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbXBDMBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbXBDMBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 07:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXBDMBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 07:01:20 -0500
Received: from ns1.suse.de ([195.135.220.2]:58989 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbXBDMBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 07:01:19 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: [RFC] Pack the vfsmount and dentry in nameidata into a struct path
Date: Sun, 4 Feb 2007 04:00:51 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200702031425.38054.agruen@suse.de> <20070204041653.GA3672@lazybastard.org>
In-Reply-To: <20070204041653.GA3672@lazybastard.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3247
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200702040400.51958.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 February 2007 20:16, Jörn Engel wrote:
> On its own, I don't like this patch too much.  It is just a form of
> mental masturbation that complicates the source.

Thanks for pointing out the masturbation thing. I was actually polling for 
comments; this single patch in itself wasn't meant to be the ultimate hot 
stuff.

> > -	inode = nd.dentry->d_inode;
> > +	inode = nd.path.dentry->d_inode;
>
> However, once we start passing struct path by reference, it should
> result in a smaller binary.

There are several components to it. Storing the dentry and vfsmount in a 
struct path allows to pass them somewhere where a struct path is expected 
without having to construct a temporary struct path object. Also, two 
parameters would become one; I believe that this could lead to somewhat 
cleaner code in some places.

The other question is whether we would want to pass such struct paths by value 
or by reference: by value would lead to roughly the same code that we have 
right now. By reference would reduce the function call overhead, but would 
blow up the code that accesses the struct path elements by about the same 
amount: getting to the dentry or vfsmount from a struct path pointer requires 
a pointer dereference.

It's hard to tell whether the code size would decrease overall with 
by-reference passing. The experiments I did didn't, but I also didn't try to 
optimize the by-reference code.

Thanks,
Andreas
