Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbZCPWzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbZCPWzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761889AbZCPWy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:54:57 -0400
Received: from mail.fieldses.org ([141.211.133.115]:38323 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761169AbZCPWy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:54:56 -0400
Date: Mon, 16 Mar 2009 18:54:24 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Igor Zhbanov <izh1979@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       Trond.Myklebust@netapp.com, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090316225424.GD17738@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com> <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com> <20090316163611.GB10959@fieldses.org> <20090316170433.GA2996@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316170433.GA2996@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:04:33PM -0500, Serge E. Hallyn wrote:
> Quoting J. Bruce Fields (bfields@fieldses.org):
> > If filesystem permissions similarly never affected the ability to create
> > device nodes, that might also be an argument against including
> > CAP_MKNOD, but it would be interesting to know the pre-capabilities
> > behavior of a uid 0 process with fsuid non-0.
> 
> The sentiment rings true, but again since before capabilities, privilege
> was fully tied to the userid, the question doesn't make sense.  Either
> you had uid 0 and could mknod, or you didn't and couldn't.  And that is
> the behavior which we unfortunately have to emulate when
> !issecure(SECURE_NOROOT|SECURE_NOSUIDFIXUP).

The historical behavior of setfsuid() is still interesting, though.
>From a quick glance at Debian's code for the (long-neglected) userspace
nfsd server, it looks like it depends on setfsuid() and the kernel to
enforce permissions for operations (including mknod).  Might be
interesting to confirm whether it has the same problem, and if so,
whether that was a problem introduced with some capability changes or
whether it always existed.

--b.
