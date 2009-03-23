Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZCWNWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZCWNWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZCWNWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:22:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35498 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZCWNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:22:01 -0400
To: serue@us.ibm.com
CC: bfields@fieldses.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20090316170433.GA2996@us.ibm.com> (serue@us.ibm.com)
Subject: unprivileged mounts vs. rmdir (was: VFS, NFS security bug? ...)
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com> <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com> <20090316163611.GB10959@fieldses.org> <20090316170433.GA2996@us.ibm.com>
Message-Id: <E1Llk5q-0000kd-IR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Mar 2009 14:21:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCs trimmed]

On Mon, 16 Mar 2009, Serge E. Hallyn wrote:
> Quoting J. Bruce Fields (bfields@fieldses.org):
> > special privilege, so don't consult filesystem permissions (do I have
> > that right?  What happened to the attempt to allow ordinary users to
> > mount?).
> 
> Well, they keep getting stalled because we don't have a good answer for
> what to do about the fact that an unprivileged user can make trees
> undeletable by pinning them with mounts.  (Miklos and Eric cc'd in case
> I didn't explain that well enough).

That's correct.

The best answer I can come up with is to allow rmdir/unlink to
automatically umount trees from their respective dentries.  Obviously
this can't be done for regular (privileged) mounts, which must keep
returning EBUSY in such situations.

But for unprivileged mounts I can't see any fundamental issue with
such an approach.

Does anyone see a problem with this?  Is there a better solution?

Thanks,
Miklos
