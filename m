Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYDPUk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYDPUk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYDPUks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:40:48 -0400
Received: from pat.uio.no ([129.240.10.15]:34656 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYDPUkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:40:47 -0400
Subject: Re: [patch 1/3] NFS: fix potential NULL pointer dereference
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <aa79d98a0804161319l4be9bb12k7bacae815b1d6d9c@mail.gmail.com>
References: <20080416174421.442716301@gmail.com>
	 <48063bc9.2234440a.747d.09ea@mx.google.com>
	 <1208369492.5376.9.camel@heimdal.trondhjem.org> <20080416181336.GA7657@cvg>
	 <1208372123.5376.43.camel@heimdal.trondhjem.org>
	 <aa79d98a0804161319l4be9bb12k7bacae815b1d6d9c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 16:40:28 -0400
Message-Id: <1208378428.8598.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 791CA48C070271DC957EFDF87FE195D375C9D105
X-UiO-SR-test: 76FB64D364420248AA5403F1959829A58147DC44
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 640 total 7929005 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-17 at 00:19 +0400, Cyrill Gorcunov wrote:
> Trond, I've just pointed the problem and its solution (which is seems
> to be a bit ugly, according to the rest nfs coding principle). So if
> you prefer to have such a check in 'walk_path' function - just say me
> that. You choose :) Thanks for comments

> > So? The defensive coding principle is that you perform validity checks
> > when the pointer is created. Otherwise, we could equally well have added
> > the NULL deref check to nfs4_path_walk()...

No, your fix was correct, it was just incomplete.

The point I was making above was that defensive programming means that
_all_ these validity/NULL pointer checks should really be done in
nfs4_validate_mount_data and nfs_validate_mount_data. We shouldn't rely
on checks in other parts of the code.

In fact, as an example: it looks to me as if the lack of a
nfs_server.hostname, leads to a lack of nfs_client->cl_hostname, which
will eventually cause an Oops if you 'cat /proc/fs/nfsfs/servers', or if
you hit the printk in nfs_update_inode(), or various other dprintk()s.

Trond

