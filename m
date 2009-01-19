Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZASRsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZASRsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZASRsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:48:42 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38781 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZASRsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:48:41 -0500
Date: Mon, 19 Jan 2009 11:48:38 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119174836.GA11295@us.ibm.com>
References: <20090118073441.GA699@redhat.com> <1232331602.3136.19.camel@zeus.themaw.net> <20090119070801.GA21686@redhat.com> <1232352677.3136.103.camel@zeus.themaw.net> <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119143046.GA8284@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 01/19, Ian Kent wrote:
> >
> > On Mon, 2009-01-19 at 13:42 +0100, Oleg Nesterov wrote:
> > >
> > > Before the patch
> > >
> > > 	sbi->oz_pgrp != task_pgrp(automount)
> > >
> > > After the patch
> > >
> > > 	sbi->oz_pgrp == task_pgrp(automount)
> > >
> > > And please note that these "!="/"==" apply to any namespace. I mean,
> > > when we call autofs_oz_mode() it does not matter in which namespace
> > > autofs_oz_mode() is executed, we compare "struct pid*", not pid_t.
> >
> > I think your saying that the option pgrp= is broken and should be
> > deprecated
> 
> No, no, sorry if I confused you.
> 
> If the "pgrp=" option was specified, the patch has no effect, and the
> code is correct with or without the patch.

But so there does still need to be a patch modifying parse_options()
to return an error if pgrp= was not specified, right?

-serge
