Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0BCB4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:56:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39763 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab0BCB4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:56:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 3 Feb 2010 10:52:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Lubos Lunak <l.lunak@suse.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
Message-Id: <20100203105236.b4a60754.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002021643240.3393@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz>
	<alpine.DEB.2.00.1002011523280.19457@chino.kir.corp.google.com>
	<201002022210.06760.l.lunak@suse.cz>
	<alpine.DEB.2.00.1002021643240.3393@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 17:41:41 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 2 Feb 2010, Lubos Lunak wrote:
> 
> > > > init
> > > >   |- kdeinit
> > > >   |  |- ksmserver
> > > >   |  |  |- kwin
> > > >   |  |- <other>
> > > >   |- konsole
> > > >      |- make
> > > >         |- sh
> > > >         |  |- meinproc4
> > > >         |- sh
> > > >         |  |- meinproc4
> > > >         |- <etc>
> > > >
> > > >  What happens is that OOM killer usually selects either ksmserver (KDE
> > > > session manager) or kdeinit (KDE master process that spawns most KDE
> > > > processes). Note that in either case OOM killer does not reach the point
> > > > of killing the actual offender - it will randomly kill in the tree under
> > > > kdeinit until it decides to kill ksmserver, which means terminating the
> > > > desktop session. As konsole is a KUniqueApplication, it forks into
> > > > background and gets reparented to init, thus getting away from the
> > > > kdeinit subtree. Since the memory pressure is distributed among several
> > > > meinproc4 processes, the badness does not get summed up in its make
> > > > grandparent, as badness() does this only for direct parents.
> > >
> > > There's no randomness involved in selecting a task to kill;
> > 
> >  That was rather a figure of speech, but even if you want to take it 
> > literally, then from the user's point of view it is random. Badness of 
> > kdeinit depends on the number of children it has spawned, badness of 
> > ksmserver depends for example on the number and size of windows open (as its 
> > child kwin is a window and compositing manager).
> > 
> 
> As I've mentioned, I believe Kame (now cc'd) is working on replacing the 
> heuristic that adds the VM size for children into the parent task's 
> badness score with a forkbomb detector. 

I stopped that as I mentioned. I'm heavily disappointed with myself and
would like not to touch oom-killer things for a while.

I'd like to conentrate on memcg for a while, which I've starved for these 3 months.

Then, you don't need to CC me.

Bye,
-Kame

