Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbXKJIjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbXKJIjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 03:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXKJIjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 03:39:46 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:52402 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbXKJIjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 03:39:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VbxATxJCtEFhF7y4EQBNhikWqCtxSlRzPe1nMfYPk3ueIXCADLNKIuiNm9E7Vnc0Uriaa3etcMO5IgCjiWWmiVRysO/+VW83eWJCrDJBjgY3uuCZVcpELFRhQpZjx59e1alnU6/ggB39L7F2f9/aY/JybNC3msIefm72+exKKqM=
Subject: Re: kernel BUG message while using jffs2
From: Alexandru DAMIAN <ddalex@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1194647963.2588.41.camel@shinybook.infradead.org>
References: <f881070f0711090708u1b77a78dlcdb504a724b22fcf@mail.gmail.com>
	 <1194647963.2588.41.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Sat, 10 Nov 2007 10:37:17 +0200
Message-Id: <1194683837.5688.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running stock kernel on a Fedora 7. uname -a tells 

Linux sandel.gameloft.org 2.6.22.9-91.fc7 #1 SMP Thu Sep 27 23:10:59 EDT
2007 i686 i686 i386 GNU/Linux

In the stock 2.6.22.9 kernel, I see a bugon on slub.c, the code is this:

2196 static struct kmem_cache *get_slab(size_t size, gfp_t flags)
2197 {
2198         int index = kmalloc_index(size);
2199 
2200         if (!index)
2201                 return NULL;
2202 
2203         /* Allocation too large? */
2204         BUG_ON(index < 0);

Hope this helps,

Cheers,
Alex

On Fri, 2007-11-09 at 17:39 -0500, David Woodhouse wrote:
> On Fri, 2007-11-09 at 17:08 +0200, Alexandru Damian wrote:
> > Hello,
> > 
> > Sorry for posting here, it seems the best spot; if I need to redirect
> > this to mtd-utils team, please tell me.
> > 
> > I'm playing around with some jffs2 files. While trying to mount (via
> > block2mtd, loop) a jffs2 system, a "kernel BUG message" appeared in
> > dmesg, with these lines:
> > 
> > kernel BUG at mm/slub.c:2204!
> 
> I don't see a BUG() or BUG_ON() anywhere near that line. What version of
> the kernel? Precisely what is at that line?
> 

