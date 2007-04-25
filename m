Return-Path: <linux-kernel-owner+w=401wt.eu-S1031126AbXDYTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031126AbXDYTfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDYTfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:35:33 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40953 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031117AbXDYTfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:35:30 -0400
To: serge@hallyn.com
CC: ebiederm@xmission.com, hpa@zytor.com, miklos@szeredi.hu,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, linux-security-module@vger.kernel.org
In-reply-to: <20070425185244.GA20688@vino.hallyn.com> (serge@hallyn.com)
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu> <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <462F87EA.1000002@zytor.com> <20070425172012.GA20336@sergelap.austin.ibm.com> <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com> <20070425175609.GB20165@vino.hallyn.com> <m1647ks3dm.fsf@ebiederm.dsl.xmission.com> <20070425185244.GA20688@vino.hallyn.com>
Message-Id: <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Apr 2007 21:33:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, I figure if the normal action is to always do
> mnt->user = current->fsuid, then for the special case we
> pass a uid in someplace.  Of course...  do we not have a
> place to do that?  Would it be a no-no to use 'data' for
> a non-fs-specific arg?

I guess it would be OK for bind, but not for new- and remounts, where
'data' is already used.

Maybe it's best to stay with fsuid after all, and live with having to
restore capabilities.  It's not so bad after all, this seems to do the
trick:

	cap_t cap = cap_get_proc();
	setfsuid(uid);
	cap_set_proc(cap);

Unfortunately these functions are not in libc, but in a separate
"libcap" library.  Ugh.

Miklos
