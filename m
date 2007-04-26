Return-Path: <linux-kernel-owner+w=401wt.eu-S1031242AbXDZO6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031242AbXDZO6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031249AbXDZO6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:58:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51523 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031242AbXDZO6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:58:01 -0400
Date: Thu, 26 Apr 2007 09:57:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serge@hallyn.com, hpa@zytor.com, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       linux-security-module@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] unprivileged mounts update
Message-ID: <20070426145733.GA10078@sergelap.austin.ibm.com>
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu> <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <462F87EA.1000002@zytor.com> <20070425172012.GA20336@sergelap.austin.ibm.com> <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com> <20070425175609.GB20165@vino.hallyn.com> <m1647ks3dm.fsf@ebiederm.dsl.xmission.com> <20070425185244.GA20688@vino.hallyn.com> <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > Right, I figure if the normal action is to always do
> > mnt->user = current->fsuid, then for the special case we
> > pass a uid in someplace.  Of course...  do we not have a
> > place to do that?  Would it be a no-no to use 'data' for
> > a non-fs-specific arg?
> 
> I guess it would be OK for bind, but not for new- and remounts, where
> 'data' is already used.
> 
> Maybe it's best to stay with fsuid after all, and live with having to
> restore capabilities.  It's not so bad after all, this seems to do the
> trick:
> 
> 	cap_t cap = cap_get_proc();
> 	setfsuid(uid);
> 	cap_set_proc(cap);
> 
> Unfortunately these functions are not in libc, but in a separate
> "libcap" library.  Ugh.

Ok, are you still planning to nix the MS_SETUSER flag, though, as Eric
suggested?  I think it's cleanest - always set the mnt->user field to
current->fsuid, and require CAP_SYS_ADMIN if the mountpoint->mnt->user !=
current->fsuid.

-serge
