Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbYAUV1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbYAUV1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758623AbYAUV0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:26:19 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60546 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbYAUV0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:26:04 -0500
To: linuxram@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
In-reply-to: <1200944886.2988.27.camel@ram.us.ibm.com> (message from Ram Pai
	on Mon, 21 Jan 2008 11:48:05 -0800)
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu> <1200944886.2988.27.camel@ram.us.ibm.com>
Message-Id: <E1JH49E-0006d6-N9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Jan 2008 22:25:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	You have removed the code that checked if the peer or
> 	master mount was in the same namespace before reporting their
> 	corresponding mount-ids. One downside of that approach is the
> 	user will see an mount_id in the output with no corresponding
> 	line to explain the details of the mount_id.  

Before the change, the peer and master ID's were basically randomly
chosen from the peers, which means, it wasn't possible to always
determine, that two mounts were peers, or that they were slaves to the
same peer group.

After the change, this is possible, since the peer ID will be the same
for all mounts which are peers.  This means, that even though the peer
ID might be in a different namespace, it is possible to determine all
peers within the same namespace by comparing their peer ID's.

> 
> 	And reporting the mount-id of a mount is some other namespace
> 	could subtly mean information-leak?

I don't think the mount ID itself can be sensitive, it really doesn't
contain any information, other than being an identifier.

> 	One other comment I had received offline from Steve French was
> 	that the patch did not consider the following case:
> 
> 	"Have you thought about whether this could handle the case in which cifs mounts with 
> 	a relative path e.g. currently
>          	mount -t cifs //server/share /mnt
> 
> 	can not be distinguished from
>         	mount -t cifs //server/share/subdirectory /mnt
> 
> 	when you run the mount command (ie the cifs "prefixpath" in this case 
> 	"/subdirectory" is not displayed)"

Why cifs not displaying '//server/share/subdirectory' as the source of
the mount?

Miklos
