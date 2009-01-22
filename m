Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZAVPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZAVPy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAVPyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:54:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49620 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZAVPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:54:18 -0500
Date: Thu, 22 Jan 2009 17:09:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090122160935.GI15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122065104.2787df2d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> straightforwad.  But it's really really sad.  It basically leaves a great
> big FIXME in there.  It'd be better to fix it.

Also it might be that it's even worse than the BKL.

> 
> We don't have a handy lock in struct file which could be borrowed.
> 
> - We could add one
> 
> - We could borrow file->f_path.dentry->d_inode->i_lock
> 
> - We could convert that field to long and use bitops (sounds nice?)

It would still require a bitlock because some state in the low
level fasync needs to be protected.

Oleg has a proposal to do this using a flag bit which seemed
reasonable to me.

-Andi

