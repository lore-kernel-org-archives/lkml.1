Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYFWQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYFWQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYFWQ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:58:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47046 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYFWQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:58:15 -0400
To: viro@ZenIV.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
In-reply-to: <E1KApHx-0007o1-Td@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 23 Jun 2008 18:53:09 +0200)
Subject: Re: [patch 3/3] vfs: fix sys_getcwd for detached mounts
References: <20080623161151.597847108@szeredi.hu> <20080623161213.116829182@szeredi.hu> <E1KApHx-0007o1-Td@pomaz-ex.szeredi.hu>
Message-Id: <E1KApMs-0007p1-2Z@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jun 2008 18:58:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Darn, this is wrong.  It should be looking at vfsmnt->mnt_namespace ==
> NULL.
> 
> Fixed patch coming up.

And the thing is: getcwd() did return garbage for detached mounts,
except if the mounted dentry was the root of the filesystem.  Which
makes the "detached:..." change slightly prone to breaking something.
Still not very likely, but...

Miklos
