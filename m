Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXDUH4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXDUH4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXDUH4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:56:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965287AbXDUH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:56:13 -0400
Date: Sat, 21 Apr 2007 00:55:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 2/8] allow unprivileged umount
Message-Id: <20070421005506.6a315bec.akpm@linux-foundation.org>
In-Reply-To: <20070420102626.825263599@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
	<20070420102626.825263599@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 12:25:34 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> +static bool permit_umount(struct vfsmount *mnt, int flags)
> +{
>
> ...
>
> +	return mnt->mnt_uid == current->uid;
> +}

Yes, this seems very wrong.  I'd have thought that comparing user_struct*'s
would get us a heck of a lot closer to being able to support aliasing of
UIDs between different namespaces.

