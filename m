Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYH1TZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYH1TZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYH1TZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:25:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44933 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYH1TZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:25:38 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <48B6EF98.4070008@kernel.org> (message from Tejun Heo on Thu, 28
	Aug 2008 20:34:00 +0200)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org>
Message-Id: <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 Aug 2008 21:25:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Tejun Heo wrote:
> Miklos Szeredi wrote:
> >> Hmmm... I was trying to stay within similar operation mechanics as other
> >> ops.  Directly accessing the caller's memory has performance benefits
> >> but that benefit can also be used by reads and writes.  So, if we're
> >> gonna do direct memory access, maybe doing it in more generic way is a
> >> better idea?
> > 
> > On the contrary: playing VM games is going to be slow.  I think this
> > approach is best suited for generic ioctl support because it
> > simplifies the kernel part.  I'd hate to add all that complexity to
> > the kernel if not absolutely necessary.
> 
> Well, it's only 240 lines with good amount of comments and iovec copying
> function.  The ioctl itself isn't too complex.  I'm a bit skeptical
> about direct access.  It can easily introduce security vulnerabilities
> as there really is no way to hold a pid.

I don't understand.  No new vulnerabilities are introduced, since it
would just use existing infrastructure.

Why is it better if the kernel does the copying of memory regions
instructed by the userspace filesystem, than if the userspace
filesystem does that copying itself?  I feel they are totally
equivalent, except that the latter needs more complexity in the
kernel.

Miklos
