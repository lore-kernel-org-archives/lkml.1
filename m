Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYFCLal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYFCLal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYFCLac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:30:32 -0400
Received: from mail2.shareable.org ([80.68.89.115]:33193 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYFCLab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:30:31 -0400
Date: Tue, 3 Jun 2008 12:30:18 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       drepper@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Message-ID: <20080603113018.GA27955@shareable.org>
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com> <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu> <20080603112221.GW28946@ZenIV.linux.org.uk> <cfd18e0f0806030427p22a274dev746e1656662f34f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0806030427p22a274dev746e1656662f34f6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> > FWIW, I very much doubt that you are right wrt required
> > permissions, though.  AFAICS, intent here is "if you can write to
> > file, you can touch the timestamps anyway" and having descriptor
> > opened for write gives that, current permissions be damned.
> 
> The standard is pretty clear on this point:
> 
> [[
> Only a process with the effective user ID equal to the user ID of the
> file, or with write access to the file, or with appropriate privileges
> may use futimens( ) or utimensat( ) with a null pointer as the times
> argument or with both tv_nsec fields set to the special value
> UTIME_NOW.
> ]]
> 
> The crucial words here are "a process ... with write access to the
> file" -- in other words, the permissions are determined by the
> process's credentials, not by the access mode of the file descriptor.
> I was not 100% sure on that to start with, so I did check it out with
> one of the folk at The Open Group, to make sure of my understanding.

Is there anything else where the file descriptor's access mode allows
doing things on Linux, but the standard requires a permissions check
each time?

-- Jamie
