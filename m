Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZASTgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZASTgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZASTf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:35:57 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:34721 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZASTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:35:56 -0500
Date: Mon, 19 Jan 2009 13:35:53 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119193553.GA18170@us.ibm.com>
References: <1232352677.3136.103.camel@zeus.themaw.net> <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119191729.GB24852@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 01/19, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 01/19, Serge E. Hallyn wrote:
> > > >
> > > > But so there does still need to be a patch modifying parse_options()
> > > > to return an error if pgrp= was not specified, right?
> > >
> > > Why? In that case we should use the caller's pgrp. This is what the
> > > current tries to do, why should the patch change this behaviour?
> >
> > Well, because Ian said that not specifying it is supposed to
> > be an error :)  I didn't quite understand why, so am fishing
> > for more info...
> 
> I think you misunderstood him. Or I am totally confused ;)
> 
> In any case. Both autofs and autofs4 use current's pgrp if this
> option was not specified, and these patches doesn't change this
> behaviour.
> 
> 
> Actually, I am very much surprized this one-liner patch has so
> many questions. Isn't it "obiously correct" ?

I'm not sure which one-liner you're talking about.  In fact,
the patch I'm looking at right now isn't the one i looked at
before my last response.  Dangit.

The patch turning the cached pid_t into a struct pid is
certainly mostly right.  It shouldn't store a pid_t.

But as for passing pid_t's in from userspace and especially
printing them out in error messages, I believe what Ian was
trying to do before, which seemed sensible, was to always
use values in the init_pid_ns.  After all, if you do a DPRINTK
with pid_vnr(somepid), then by the time a human reads the logs
the subjective pidns might no longer exist.  So for logs I'd
tend to agree with printing out the pid_t in the init_pid_ns.

-serge
