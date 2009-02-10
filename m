Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZBJMpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZBJMpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZBJMpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:45:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40505 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbZBJMpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:45:35 -0500
Date: Tue, 10 Feb 2009 12:45:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: fix possible use after free
Message-ID: <20090210124527.GA28946@ZenIV.linux.org.uk>
References: <4991497B.4030200@cn.fujitsu.com> <6599ad830902100215o185edd31k8731e033717dbb49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830902100215o185edd31k8731e033717dbb49@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 02:15:36AM -0800, Paul Menage wrote:
> On Tue, Feb 10, 2009 at 1:31 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> > In cgroup_kill_sb(), root is freed before sb is detached from the list,
> > so another sget() may find this sb and call cgroup_test_super(),
> > which will access the root that has been freed.
> 
> I think that I'd assumed that by the time we get to cgroup_kill_sb()
> there's no chance of the sb being resurrected by sget().

There is none.  grab_super() will fail to get it, so sget() will go
through retry logics.  Which doesn't mean that test won't be called
on it in the meanwhile.
