Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYAUVio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYAUVio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYAUVif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:38:35 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43243 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYAUVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:38:34 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
In-reply-to: <20080121203249.GB5536@sergelap.austin.rr.com> (serue@us.ibm.com)
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
References: <20080116123147.466284860@szeredi.hu> <20080116123433.126167584@szeredi.hu> <20080121203249.GB5536@sergelap.austin.rr.com>
Message-Id: <E1JH4Kz-0006gt-MC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Jan 2008 22:37:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What do you think about doing this only if FS_SAFE is also set,
> so for instance at first only FUSE would allow itself to be
> made user-mountable?
> 
> A safe thing to do, or overly intrusive?

It goes somewhat against the "no policy in kernel" policy ;).  I think
the warning in the documentation should be enough to make sysadmins
think twice before doing anything foolish:

> +Care should be taken when enabling this, since most
> +filesystems haven't been designed with unprivileged mounting
> +in mind.
> +

BTW, filesystems like 'proc' and 'sysfs' should also be safe, although
the only use for them being marked safe is if the users are allowed to
umount them from their private namespace (otherwise a 'mount --bind'
has the same effect as a new mount).

Thanks,
Miklos
