Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYDNJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYDNJ7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYDNJ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:58:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53770 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYDNJ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:58:48 -0400
To: jamie@shareable.org
CC: miklos@szeredi.hu, dwmw2@infradead.org, hch@infradead.org,
       akpm@linux-foundation.org, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080414094215.GD2076@shareable.org> (message from Jamie Lokier
	on Mon, 14 Apr 2008 10:42:15 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org>
Message-Id: <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Apr 2008 11:58:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And I didn't advocate moving
> > ntfs to fuse, still that was done
> 
> Yes, that's quite annoying as FUSE doesn't work with my architecture,
> so I can't use the only good NTFS driver.... grr! :-)

I'm not quite getting this joke :)

> FUSE is great for user-mounted filesystems, though.  Having to use
> "su" in shell scripts which modify loopback filesystems was always
> very ugly.
> 
> I don't see why we need such a dichotomy, though.  The VFS API is
> sensible enough that it should be possible to compile the same
> filesystem code to run in kernel or in FUSE.

Well, yeah:

  http://lkml.org/lkml/2006/2/27/148

Oh, you mean without having to run the whole kernel around the
filesystem?  Well, that's a bit more tricky: filesystems use not just
the VFS API, but the block, VM, SLAB, etc. APIs as well.  Porting all
of these to userspace and keeping them in sync with the kernel changes
doesn't sound much fun.

Miklos
