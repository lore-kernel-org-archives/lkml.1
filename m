Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbXEWLjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbXEWLjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbXEWLj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:39:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57505 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938AbXEWLj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:39:26 -0400
Date: Wed, 23 May 2007 12:39:25 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523113925.GT4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> <20070523102437.GS4095@ftp.linux.org.uk> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When the real superblock is created.  It could even be the _same_
> super block as the real one.  There'd be just the problem of anchoring
> the dir-on-file dentries somewhere...
> 
> Or with fuse the dir-on-file mount can just come from any mounted
> filesystem, again possibly the same one as the parent.  I do actually
> test with this.  The userspace filesystem supplies a file descriptor,
> from which the struct path is extracted and returned from ->enter().

Then I do not understand what this mechanism could be used for, other
than an odd way to twist POSIX behaviour and see how much of the userland
would survive that.  Certainly not useful for your "look into tarball
as a tree", unless you seriously want to scan the entire damn fs for
tarballs at mount time and set up a superblock for each.  And for per-file
extended attributes/forks/whatever-you-call-that-abomination it also
obviously doesn't help, since you lose them for directories.

IOW, what uses do you have in mind?  Complete scenario, please...
