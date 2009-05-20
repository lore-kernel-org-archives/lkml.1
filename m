Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZETJFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZETJFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZETJFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:05:41 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42357 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZETJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:05:40 -0400
To: vaurora@redhat.com
CC: miklos@szeredi.hu, jblunck@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
In-reply-to: <20090519172327.GB722@shell> (message from Valerie Aurora on Tue,
	19 May 2009 13:23:27 -0400)
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu> <20090519172327.GB722@shell>
Message-Id: <E1M6hjr-00032A-EX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 20 May 2009 11:05:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Valerie Aurora wrote:
> As Jan said, readdir() of read-only unioned file systems works with a
> tmpfs top layer.  If you think about it, this is the exact equivalent
> of the version of union mounts which used the in-kernel caching
> approach - except that it's better, because it reuses existing code
> and caches between readdir() calls.  Cool, huh?

Yeah... OTOH tmpfs is probably a way too heavyweight solution for
cases where memory is short, and union mounts would typically be used
on such systems.

The big reason why kernel impementation of readdir is hard is that
unswappable kernel memory needs to be used for caching directory
contents while the directory is open.  Well, tmpfs does the same,
dentries and inodes are _not_ swappable, and they gobble up memory.

So where's the advantage over implementing a thin deduplicating and
caching layer for union mounts?

Thanks,
Miklos
