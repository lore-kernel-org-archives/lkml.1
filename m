Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXDVHVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXDVHVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXDVHVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:21:51 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:48369 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbXDVHVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:21:51 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m1fy6tkeu7.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 5/8] allow unprivileged bind mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102641.165244483@szeredi.hu> <m1fy6tkeu7.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfWML-00048U-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 09:19:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > Allow bind mounts to unprivileged users if the following conditions
> > are met:
> >
> >   - mountpoint is not a symlink or special file
> 
> Why?  This sounds like a left over from when we were checking permissions.

Hmm, yes.  Don't know.  Maybe only the symlink check.

Bind mounts of directory over non-directy, and vica versa are already
excluded, even for root.

> >   - parent mount is owned by the user
> >   - the number of user mounts is below the maximum
> >
> > Unprivileged mounts imply MS_SETUSER, and will also have the "nosuid"
> > and "nodev" mount flags set.
> 
> So in principle I agree, but in detail I disagree.
> 
> capable(CAP_SETUID) should be required to leave MNT_NOSUID clear.
> capable(CAP_MKNOD) should be required to leave MNT_NODEV clear.
> 
> I.e.  We should not special case this as a user mount but rather
> simply check to see if the user performing the mount has the appropriate
> capabilities to allow the flags.

Sounds sane.  Will fix.

Miklos
