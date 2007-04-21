Return-Path: <linux-kernel-owner+w=401wt.eu-S1030266AbXDUILN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266AbXDUILN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXDUILN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:11:13 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:36543 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030266AbXDUILL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:11:11 -0400
To: akpm@linux-foundation.org
CC: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <20070421005506.6a315bec.akpm@linux-foundation.org> (message from
	Andrew Morton on Sat, 21 Apr 2007 00:55:06 -0700)
Subject: Re: [patch 2/8] allow unprivileged umount
References: <20070420102532.385211890@szeredi.hu>
	<20070420102626.825263599@szeredi.hu> <20070421005506.6a315bec.akpm@linux-foundation.org>
Message-Id: <E1HfAf8-0002Ky-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Apr 2007 10:09:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static bool permit_umount(struct vfsmount *mnt, int flags)
> > +{
> >
> > ...
> >
> > +	return mnt->mnt_uid == current->uid;
> > +}
> 
> Yes, this seems very wrong.  I'd have thought that comparing user_struct*'s
> would get us a heck of a lot closer to being able to support aliasing of
> UIDs between different namespaces.
> 

OK, I'll fix this up.

Actually an earlier version of this patch did use user_struct's but
I'd changed it to uids, because it's simpler.  I didn't think about
this being contrary to the id namespaces thing.

Miklos
