Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYJ0UwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYJ0UwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYJ0Uvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:51:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59457 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbYJ0Uvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:51:52 -0400
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for
	checkpoint	restart
From: Matt Helsley <matthltc@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Peter Chubb <peterc@gelato.unsw.edu.au>
In-Reply-To: <4905F648.4030402@cs.columbia.edu>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
	 <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu>
	 <20081021124130.a002e838.akpm@linux-foundation.org>
	 <20081021202410.GA10423@us.ibm.com>	<48FE82DF.6030005@cs.columbia.edu>
	 <20081022152804.GA23821@us.ibm.com>	<48FF4EB2.5060206@cs.columbia.edu>
	 <87tzayh27r.wl%peter@chubb.wattle.id.au> <49059FED.4030202@cs.columbia.edu>
	 <1225125752.12673.79.camel@nimitz> <4905F648.4030402@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 13:51:45 -0700
Message-Id: <1225140705.5115.40.camel@enoch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 13:11 -0400, Oren Laadan wrote:
> Dave Hansen wrote:
> > On Mon, 2008-10-27 at 07:03 -0400, Oren Laadan wrote:
> >>> In our implementation, we simply refused to checkpoint setid
> >> programs.
> >>
> >> True. And this works very well for HPC applications.
> >>
> >> However, it doesn't work so well for server applications, for
> >> instance.
> >>
> >> Also, you could use file system snapshotting to ensure that the file
> >> system view does not change, and still face the same issue.
> >>
> >> So I'm perfectly ok with deferring this discussion to a later time :)
> > 
> > Oren, is this a good place to stick a process_deny_checkpoint()?  Both
> > so we refuse to checkpoint, and document this as something that has to
> > be addressed later?
> 
> why refuse to checkpoint ?

	If most setuid programs hold privileged resources for extended periods
of time after dropping privileges then it seems like a good idea to
refuse to checkpoint. Restart of those programs would be quite
unreliable unless/until we find a nice solution.

> if I'm root, and I want to checkpoint, and later restart, my sshd server
> (assuming we support listening sockets) - then why not ?
> we can just let it be, and have the restart fail (if it isn't root that
> does the restart); perhaps add something like warn_checkpoint() (similar
> to deny, but only warns) ?

	How will folks not specializing in checkpoint/restart know when to use
this as opposed to deny?

	Instead, how about a flag to sys_checkpoint() -- DO_RISKY_CHECKPOINT --
which checkpoints despite !may_checkpoint?

Cheers,
	-Matt Helsley

