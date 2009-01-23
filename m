Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZAWMHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZAWMHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 07:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZAWMHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 07:07:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54348 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbZAWMHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 07:07:36 -0500
Date: Fri, 23 Jan 2009 12:51:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs4: turn ->oz_pgrp into "struct pid *"
Message-ID: <20090123114129.GC12684@redhat.com>
References: <20090118073449.GA707@redhat.com> <1232686627.3011.26.camel@zeus.themaw.net> <20090123080617.GA4002@redhat.com> <1232701988.3011.42.camel@zeus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232701988.3011.42.camel@zeus.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Ian Kent wrote:
>
> On Fri, 2009-01-23 at 09:06 +0100, Oleg Nesterov wrote:
> > On 01/23, Ian Kent wrote:
> > >
> > > On Sun, 2009-01-18 at 08:34 +0100, Oleg Nesterov wrote:
> > > >
> > > > I guess autofs4_show_options()->pid_vnr() is not exactly right, but hopefully
> > > > not worse than the current code.
> > >
> > > But shouldn't pid_vnr(sbi->oz_pgrp) report the pid as seen in the
> > > namespace of the calling process? In which case the only problem would
> > > be listing the mount table from a subordinate namespace that cannot see
> > > the process which did the mount, assuming fs namespace is not linked in
> > > some strict way to pid namespace, this could give an odd result. What
> > > might happen in this case Oleg?
> > 
> > Yes, nothing bad can happen. pid_vnr() just returns 0 if the calling
> > process can't see the namespace.
> > 
> > But I was worried about the case when, say, we are looking at
> > /subnamespace_root_mount/proc/mounts.
> > 
> > In that case pid_vnr() will report the pid_t in the global namespace,
> > this differs from the case when this file is read by its own namespace
> > as /proc/mounts.
> > 
> > I do not know whether this is right or not, though.
> 
> Right, but mostly a source of confusion than anything else as things
> will still function OK. Not sure how to deal with that!

Yes. But just in case, please note that the current code is just
wrong in this respect, it always reports the "global" pid_t which
doesn't make sense for the sub-namespace.

Oleg.

