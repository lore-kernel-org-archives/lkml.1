Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXBDEUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXBDEUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 23:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXBDEUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 23:20:25 -0500
Received: from lazybastard.de ([212.112.238.170]:58111 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXBDEUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 23:20:24 -0500
Date: Sun, 4 Feb 2007 04:16:53 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] Pack the vfsmount and dentry in nameidata into a struct path
Message-ID: <20070204041653.GA3672@lazybastard.org>
References: <200702031425.38054.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702031425.38054.agruen@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 February 2007 14:25:37 -0800, Andreas Gruenbacher wrote:
> 
> While we store the (dentry, nameidata) in struct file as a struct path, we do 
> not do so in struct nameidata at the moment. Here is a patch that changes 
> that. The changes are syntactic only; gcc should generate identical code.
> 
> So what is this good for?
> 
> Well, we currently pass around (dentry, vfsmount) pairs in a number of places. 
> With this change, these pairs of objects are embedded in a struct path for 
> all file lookup oprations or open files. We could start passing around struct 
> paths instead of (dentry, vfsmount) pairs, without having to construct 
> temporary struct path objects. This could lead to nice code cleanups. The 
> struct paths could be passed by value or by reference.
> 
> Opinions?

On its own, I don't like this patch too much.  It is just a form of
mental masturbation that complicates the source.

> -	inode = nd.dentry->d_inode;
> +	inode = nd.path.dentry->d_inode;

However, once we start passing struct path by reference, it should
result in a smaller binary.  So if this patch is followed by others, as
you indicated, and the overall result is a measurably smaller binary,
I'm all for it.

Jörn

-- 
Joern's library part 1:
http://lwn.net/Articles/2.6-kernel-api/
