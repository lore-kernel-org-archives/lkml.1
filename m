Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZAFUf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZAFUf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZAFUfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:35:46 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60638 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZAFUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:35:45 -0500
To: penguin-kernel@i-love.sakura.ne.jp
CC: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200901060322.n063MBOt046756@www262.sakura.ne.jp> (message from
	Tetsuo Handa on Tue, 06 Jan 2009 12:22:11 +0900)
Subject: Re: [PATCH] Introduce d_realpath().
References: <200901060322.n063MBOt046756@www262.sakura.ne.jp>
Message-Id: <E1LKIeB-0006qv-Bv@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 Jan 2009 21:35:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009, Tetsuo Handa wrote:
> Al, thank you very much for processing security_path_*() patch.
> Now James is reviewing our patch and he suggested
> following parts need your acknowledgments.
> Will you review and ACK for introducing a variant of d_path()?
> 
> --------------------
> Subject: Introduce d_realpath().
> 
> To remove factors that make pathname based access control difficult
> (e.g. symbolic links, "..", "//", chroot() etc.), a variant of d_path()
> which traverses up to the root of the namespace is needed.
> 
> This patch introduces d_realpath(), a variant of d_path().
> While d_path() stops traversing at current->fs->root,
> d_realpath() doesn't stop traversiong at current->fs->root.
> 
> Three differences compared to d_path().
> (1) Ignores current process's root directory.

I'd suggest calling __d_path() and passing in the namespace root
instead of the process root.  That would be a lot simpler and result
in less code duplication.

> (2) Trailing '/' is added if the pathname refers to a directory.

Caller can do this.

> (3) /proc/PID/ is represented as /proc/self/ if PID equals current->tgid.

This too.  Such hacks really don't belong in generic VFS functions.

Thanks,
Miklos
