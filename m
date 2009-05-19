Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZESQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZESQQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZESQQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:16:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34423 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZESQQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:16:04 -0400
To: jblunck@suse.de
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
In-reply-to: <1242662968-11684-22-git-send-email-jblunck@suse.de> (message
	from Jan Blunck on Mon, 18 May 2009 18:09:17 +0200)
Subject: Re: [PATCH 21/32] union-mount: Make lookup work for union-mounted file systems
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-22-git-send-email-jblunck@suse.de>
Message-Id: <E1M6Ryq-0001RP-Oe@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 May 2009 18:15:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Jan Blunck wrote:
> On union-mounted file systems the lookup function must also visit lower layers
> of the union-stack when doing a lookup. This patches add support for
> union-mounts to cached lookups and real lookups.
> 
> We have 3 different styles of lookup functions now:
> - multiple pathname components, follow mounts, follow union, follow symlinks
> - single pathname component, doesn't follow mounts, follow union, doesn't
>   follow symlinks
> - single pathname component doesn't follow mounts, doesn't follow unions,
>   doesn't follow symlinks

Ugh...  I do wonder if this could be done in a less complicated way,
there does seem to be a fair amount of duplication between these
functions.

Worse, it looks like there are still i_mutex lock ordering issues
(__hash_lookup_topmost()/__hash_lookup_build_union()).  What happens
if two separate unions of two filesystems are built where the order of
branches is reversed?

Thanks,
Miklos
