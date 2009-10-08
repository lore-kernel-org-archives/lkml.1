Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZJHNfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZJHNfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZJHNfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:35:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48044 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbZJHNfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:35:08 -0400
To: Jamie Lokier <jamie@shareable.org>
CC: miklos@szeredi.hu, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       dhowells@redhat.com, hch@infradead.org, adilger@sun.com,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091008132636.GA29691@shareable.org> (message from Jamie Lokier
	on Thu, 8 Oct 2009 14:26:36 +0100)
Subject: Re: [PATCH v2] vfs: new O_NODE open flag
References: <E1MvonW-0004rO-4A@pomaz-ex.szeredi.hu> <20091008132636.GA29691@shareable.org>
Message-Id: <E1Mvt87-0005Ne-K0@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 Oct 2009 15:34:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Jamie Lokier wrote:
> fchmodat(2) says:
> 
>        AT_SYMLINK_NOFOLLOW
>               If pathname is a symbolic link, do not dereference it:
>               instead operate on the link itself.  This flag is not
>               currently implemented.
> 
> If the flag were implemented, it would make sense for fchmod() on a
> symlink to succeed, wouldn't it?

I think allowing permission bits to be changed for symlinks would lead
to a mess.  It doesn't much make any sense anyway.

A logical implementation for fchmodat(..., AT_SYMLINK_NOFOLLOW) would be to
return an error if the target is a symlink (instead of dereferencing
it).

Thanks,
Miklos
