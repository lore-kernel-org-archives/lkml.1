Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYHQX3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYHQX3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 19:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHQX3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 19:29:42 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:50461 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYHQX3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 19:29:41 -0400
Message-ID: <48A8B44E.4090908@kernel.org>
Date: Sun, 17 Aug 2008 16:29:18 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fix NPTL thread iterator construct in cap_set_pg()
References: <b040c32a0808150924h2b93529aj803e0b923e1f96f3@mail.gmail.com>
In-Reply-To: <b040c32a0808150924h2b93529aj803e0b923e1f96f3@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ken,

In 2.2.0, pre-LSM and NPTL, this code looked like this:

     read_lock(&tasklist_lock);
     for_each_task(target) {
             if (target->pgrp != pgrp)
                     continue;
             target->cap_effective   = *effective;
             target->cap_inheritable = *inheritable;
             target->cap_permitted   = *permitted;
     }
     read_unlock(&tasklist_lock);

that is, if a process is in the process group, it got its capabilities
changed.

So far as I can tell, I've not touched this code since it looked like
the above, so I can't really comment on the motivation for the thread
iterator changes. I'm also going to have to read up on NPTL to say
anything credible on this front.

In general, its very hard to get a system state in which this code is
run, so it wouldn't surprise me if these thread iterator changes have
never been tested.

Finally, I've very much in favor of deleting any code that modifies the
capabilities of another process/thread; see the #if[n]def
CONFIG_SECURITY_FILE_CAPABILITIES sections of this file, so any fix for
this (which, if needed, should be adopted) may also be short-lived...

Cheers

Andrew

Ken Chen wrote:
> The usage of while_each_pid_task() construct in cap_set_pg() looks incorrect.
> The macro is meant to form 'do ... while' loop instead of a simple while loop.
> I think currently it will skip thread leader of a NPTL process.
> 
> Fix by convert to 'do ... while' style.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIqLRO+bHCR3gb8jsRAnFGAJoDm9VxcpmOYqEuaWmaVrnNWkb9owCgzOPH
6tG3n4GMsW8oNX4MiNiJ3FQ=
=obJY
-----END PGP SIGNATURE-----
