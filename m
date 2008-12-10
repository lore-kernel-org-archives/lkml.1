Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYLJV1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYLJV1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYLJV1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:27:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756058AbYLJV1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:27:14 -0500
Date: Wed, 10 Dec 2008 13:26:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Flynn <davidf+nntp@woaf.net>
Cc: linux-kernel@vger.kernel.org, "Ray Lee" <ray-lk@madrabbit.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>, pkpatel.lists@gmail.com,
       linux-nfs@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.26.3 kernel - progressive slowdown over NFS
Message-Id: <20081210132628.55991b93.akpm@linux-foundation.org>
In-Reply-To: <slrngjt7b4.d62.davidf+nntp@dog.thdo.woaf.net>
References: <f4e12c70809091747rd58165ahaa6594a35752c6ef@mail.gmail.com>
	<slrngjt7b4.d62.davidf+nntp@dog.thdo.woaf.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's restored)

Please always do reply-to-all when working with kernel people.  It's
important.

Thanks.

On Tue, 9 Dec 2008 16:31:32 +0000 (UTC)
David Flynn <davidf+nntp@woaf.net> wrote:

> On 2008-09-10, Priyank Patel <pkpatel.lists@gmail.com> wrote:
> > We have a simple python program which keeps running a C loop to lstat
> > NFS mounted directories.  We are seeing some weird behavior w.r.t. the
> > run-time of this program on 2.6.26.3 kernel vs 2.6.24 kernel.
> >
> > The run-time of the following code increases over time on the 2.6.26.3
> > kernel, whereas remains flat (as expected) on the 2.6.24 kernel.
> 
> I'm seeing a similar effect, and ran a benchmark pre and post reboot:
> 
>  $ strace -T /usr/sbin/bonnie++ -d . -s 0 -f -n 1 >/tmp/bonnie-r44237-netslow 2>&1
>  ...reboot...
>  $ strace -T /usr/sbin/bonnie++ -d . -s 0 -f -n 1 >/tmp/bonnie-r44237-netfast 2>&1
> 
> Graphs of the operations are avaliable:
>   http://davidf.woaf.net/nfsfail-2.6.26/
> 
> In particular http://davidf.woaf.net/nfsfail-2.6.26/r44237-stat.pdf
> 
> r44237-* was a machine with a 28 day uptime and
> r44088-* is an identical machine with 14 day uptime.
> 
> The graphs show times as recorded by strace for each syscall (points), a
> cumulative frequency plot is also drawn on the same graph (lines).
> yellow-orange points/lines are before the reboot, purple afterwards.
> 
> The machines are part of a cluster with a r/o nfsroot and common debian
> stock kernel:
>  Linux r44088 2.6.26-1-amd64 #1 SMP Sat Aug 2 11:15:08 GMT 2008 x86_64 GNU/Linux
> 
> Other nfs filesystems are also mounted; all nfs mounts are nfsv3 over udp.
> 
> Has this issue been identified or resolved in 2.6.27?
> 
> Extra logs can be provided if required.
> 
> ..david


