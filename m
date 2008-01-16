Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYAPWf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYAPWf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbYAPWcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:32:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757924AbYAPWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:32:16 -0500
Date: Wed, 16 Jan 2008 14:30:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
Message-Id: <20080116143051.ec488f3d.akpm@linux-foundation.org>
In-Reply-To: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 23:12:31 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> The reason, why this patch was dug up, is that if the bdi-sysfs patch
> is going to use device numbers to identify BDIs, then there should be
> a way for the user to map the device number into mount(s).
> 
> But it's useful regardless of the bdi-sysfs patch.

Don't know what that is.

> Can this be added to -mm?
> 
> In theory it could break userspace, but I think it's very unlikely to
> do so, because stuff is added only at the end of the lines, and
> because most programs probably parse it through the libc interface
> which is not broken by this change.  Despite this, it should be tested
> on as many systems as possible.

Seems like a plain bad idea to me.  There will be any number of home-made
/proc/mounts parsers and we don't know what they do.

> - for mount ID's use IRA instead of a 32bit counter, which could overflow

don't know what an IRA is.

> - print canonical ID's (smallest one within the peer group) for peers
>   and master, this is more useful, than a random ID within the same namespace
> - fix a couple of small bugs
> - style fixes
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Both the newly-added inlines in this patch are wrong.  They will result in
a larger and slower kernel.  This should be very well known by now.

