Return-Path: <linux-kernel-owner+w=401wt.eu-S1423252AbXDYHUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423252AbXDYHUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423257AbXDYHUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:20:06 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:52630 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423252AbXDYHTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:19:49 -0400
To: kzak@redhat.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <20070425000414.GH14086@petra.dvoda.cz> (message from Karel Zak
	on Wed, 25 Apr 2007 02:04:14 +0200)
Subject: Re: [patch 0/8]  mount ownership and unprivileged mount syscall (v4)
References: <20070420102532.385211890@szeredi.hu> <20070425000414.GH14086@petra.dvoda.cz>
Message-Id: <E1Hgblk-00045y-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Apr 2007 09:18:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The following extra security measures are taken for unprivileged
> > mounts:
> > 
> >  - usermounts are limited by a sysctl tunable
> >  - force "nosuid,nodev" mount options on the created mount
> 
>  The original userspace "user=" solution also implies the "noexec"
>  option by default (you can override the default by "exec" option).

Unlike "nosuid" and "nodev", I don't think "noexec" has real security
benefits.

>  It means the kernel based solution is not fully compatible ;-(

Oh, I don't think that matters.  For traditional /etc/fstab based user
mounts, mount(8) will have to remain suid-root, the kernel can't
replace the fstab check.

In fact the latest patches don't even support these "legacy" user
mounts too well: setting the owner of a mount gives not only umount
privilege, but the ability to submount.  This is not necessarily a
good thing for these kinds of user mounts.

We could add a new "nosubmount" or similar flag, to prevent
submounting, but that again would go against the simplicity of the
current approach, so I'm not sure it's worth it.

Miklos
