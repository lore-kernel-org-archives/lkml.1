Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbZAWJNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbZAWJNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZAWJNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:13:16 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47733 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbZAWJNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:13:14 -0500
X-Sasl-enc: X8xm9vEodrELqWbHuz7jeUep4087+d7nMjuSpKbkpeEc 1232701992
Subject: Re: [PATCH] autofs4: turn ->oz_pgrp into "struct pid *"
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090123080617.GA4002@redhat.com>
References: <20090118073449.GA707@redhat.com>
	 <1232686627.3011.26.camel@zeus.themaw.net>
	 <20090123080617.GA4002@redhat.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 18:13:08 +0900
Message-Id: <1232701988.3011.42.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 09:06 +0100, Oleg Nesterov wrote:
> On 01/23, Ian Kent wrote:
> >
> > On Sun, 2009-01-18 at 08:34 +0100, Oleg Nesterov wrote:
> > >
> > > I guess autofs4_show_options()->pid_vnr() is not exactly right, but hopefully
> > > not worse than the current code.
> >
> > But shouldn't pid_vnr(sbi->oz_pgrp) report the pid as seen in the
> > namespace of the calling process? In which case the only problem would
> > be listing the mount table from a subordinate namespace that cannot see
> > the process which did the mount, assuming fs namespace is not linked in
> > some strict way to pid namespace, this could give an odd result. What
> > might happen in this case Oleg?
> 
> Yes, nothing bad can happen. pid_vnr() just returns 0 if the calling
> process can't see the namespace.
> 
> But I was worried about the case when, say, we are looking at
> /subnamespace_root_mount/proc/mounts.
> 
> In that case pid_vnr() will report the pid_t in the global namespace,
> this differs from the case when this file is read by its own namespace
> as /proc/mounts.
> 
> I do not know whether this is right or not, though.

Right, but mostly a source of confusion than anything else as things
will still function OK. Not sure how to deal with that!

Ian


