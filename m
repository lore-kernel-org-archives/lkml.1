Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYICORx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYICORx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYICORf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:17:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47760 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbYICORe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:17:34 -0400
From: Andrey Mirkin <major@openvz.org>
To: Louis.Rilling@kerlabs.com
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Date: Wed, 3 Sep 2008 18:19:57 +0400
User-Agent: KMail/1.8.2
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1220439476-16465-1-git-send-email-major@openvz.org> <20080903134951.GQ14473@hawkmoon.kerlabs.com> <20080903140636.GS14473@hawkmoon.kerlabs.com>
In-Reply-To: <20080903140636.GS14473@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031819.58057.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 18:06 Louis Rilling wrote:
> On Wed, Sep 03, 2008 at 03:49:51PM +0200, Louis Rilling wrote:
> > On Wed, Sep 03, 2008 at 02:57:47PM +0400, Andrey Mirkin wrote:
> > > This patchset introduces kernel based checkpointing/restart as it is
> > > implemented in OpenVZ project. This patchset has limited functionality
> > > and are able to checkpoint/restart only single process. Recently Oren
> > > Laaden sent another kernel based implementation of checkpoint/restart.
> > > The main differences between this patchset and Oren's patchset are:
> > >
> > > * In this patchset checkpointing initiated not from the process
> > > (right now we do not have a container, only namespaces), Oren's
> > > patchset performs checkpointing from the process context.
> > >
> > > * Restart in this patchset is initiated from process, which restarts a
> > > new process (in new namespaces) with saved state. Oren's patchset uses
> > > the same process from which restart was initiated and restore saved
> > > state over it.
> > >
> > > * Checkpoint/restart functionality in this patchset is implemented as a
> > > kernel module
> > >
> > >
> > > As checkpointing is initiated not from the process which state should
> > > be saved we should freeze a process before saving its state. Right now
> > > Container Freezer from Matt Helsley can be used for this.
> > >
> > > This patchset introduce only a concept how kernel based
> > > checkpointing/restart can be implemented and are able to
> > > checkpoint/restart only a single process with simple VMAs.
> > >
> > > I've tried to split my patchset in small patches to make review more
> > > easier.
> >
> > Thank you Andrey for having highlighted the differences with Oren's
> > approach, and for having split this patchset. Few remarks in reply to the
> > patches.
>
> Forgot a global comment: you will probably get the same (rather pointless
> for a proof of concept, IMHO) requests as Oren got, to
> 1) improve coding style:
>   a) especially avoid error handling like:
> 	err = foo();
> 	if (!err)
> 		err = bar();
> 	if (!err)
> 		err = baz();
>
> and prefer
> 	err = foo();
> 	if (err)
> 		goto foo_err;
> 	err = bar();
> 	...
>
>   b) do not write conditions on a single line, like
> 	if (foo) bar;
>
> 2) put arch-dependent code in arch/ subdirs.
> 3) I probably forgot other ones.
>
> I obviously do not personally request you to take these requests into
> account ;)

Thanks for comments.
Unfortunately I have missed 2-3 weeks of discussion of Oren's patches.
Right now I'm reading all threads devoted to checkpointing.
I'll take into account you comments and I'll try to fix all comments in next 
version.

Thanks,
Andrey
