Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYEERk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYEERk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYEERku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:40:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36089 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYEERku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:40:50 -0400
Date: Mon, 5 May 2008 18:40:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: weigelt@metux.de, linux-kernel@vger.kernel.org
Subject: Re: VFS + path walktrough
Message-ID: <20080505174048.GP5882@ZenIV.linux.org.uk>
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 07:33:00PM +0200, Miklos Szeredi wrote:

> > This is still wrong.  We not just pass the pathname to filesystem (note
> > that you still need to deal with symlinks),
> 
> Symlinks are easy: filesystem just needs to *stop* the resolution the
> moment it finds one.

That assumes you see types of objects as you do multi-step walk...

> >  Take a look at 9P walk - it does *not* give
> > you anything resembling stat, you just get qids of intermediates.
> 
> Which is exactly what's needed to populate the dentry tree, no?

No - you need inodes as well (i.e. as the absolute least you want
mode and ownership).  Which is to say, you need to issue stat on
each component in such situation anyway.  Not a win...
