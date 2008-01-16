Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYAPUel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYAPUel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAPUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:34:31 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:32845 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYAPUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:34:30 -0500
To: vapier@gentoo.org
CC: miklos@szeredi.hu, util-linux-ng@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <200801160817.12812.vapier@gentoo.org> (message from Mike
	Frysinger on Wed, 16 Jan 2008 08:17:10 -0500)
Subject: Re: [patch] util-linux-ng: unprivileged mounts support
References: <E1JF7Xh-0003q3-Qv@pomaz-ex.szeredi.hu> <200801160817.12812.vapier@gentoo.org>
Message-Id: <E1JFEx0-0004tn-TZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Jan 2008 21:33:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is an experimental patch for supporing unprivileged mounts and
> > umounts.  The following features are added:
> 
> same feedback as last time ... the cap stuff needs to be made optional and 
> proper header checks added to configure ...

Later, sure.  For now, I'm concentrating on the actual functionality.

> > 1) If mount/umount are suid, first try without privileges.
> >
> > This is done by forking, dropping privileges in child, and redirecting
> > stderr to /dev/null.  If this succeeds, then parent exits with zero
> > exit code.  Otherwise parent continues normally (with privileges).
> > This isn't perfect, because the wrong error message will be printed if
> > mount/umount failed not because of insufficient privileges, but some
> > other error (e.g. mountpoint busy).
> 
> this normalization of error information does kind of suck ... but i
> think the way it's written, the end user will still get the real
> answer the second time around when the mount is attempted with root
> privs and not stderr sent to /dev/null ?

No, for example the user will get: "only root can umount foo" instead
of "foo is busy", which is very misleading, if the user _can_ umount
foo.

Miklos
