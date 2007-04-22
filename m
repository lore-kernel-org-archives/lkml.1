Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXDVHXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXDVHXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965292AbXDVHXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:23:50 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:52865 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158AbXDVHXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:23:49 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m17is5kdyw.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 8/8] allow unprivileged fuse mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102656.364689151@szeredi.hu> <m17is5kdyw.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfWPE-00049L-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 09:22:44 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/*
> > +	 * For unprivileged mounts use current uid/gid.  Still allow
> > +	 * "user_id" and "group_id" options for compatibility, but
> > +	 * only if they match these values.
> > +	 */
> > +	if (!capable(CAP_SYS_ADMIN)) {
> > +		d->user_id = current->uid;
> > +		d->user_id_present = 1;
> > +		d->group_id = current->gid;
> > +		d->group_id_present = 1;
> > +
> > +	}
> 
> CAP_SETUID is the appropriate capability...
> 
> This is not a dimension we have not fully explored.
> What is the problem with a user controlled mount having different
> uid and gid values.
> 
> Yes they map into different users but how is this a problem.
> The only problem that I can recall is the historic chown problem
> where you could give files to other users and mess up their quotas.
> 
> Or is the problem other users writing to this user controlled
> filesystem?

Yes.  Or even just a suid process trying to access the user controlled
filesystem.  See Documentation/filesystems/fuse.txt for the gory
details.

Eric, thanks for the detailed review :)

Miklos
