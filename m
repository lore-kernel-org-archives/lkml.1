Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYJ0VUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYJ0VUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYJ0VUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:20:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49213 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYJ0VUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:20:39 -0400
Date: Mon, 27 Oct 2008 16:20:36 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Peter Chubb <peterc@gelato.unsw.edu.au>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Message-ID: <20081027212036.GA32162@us.ibm.com>
References: <20081021124130.a002e838.akpm@linux-foundation.org> <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu> <20081022152804.GA23821@us.ibm.com> <48FF4EB2.5060206@cs.columbia.edu> <87tzayh27r.wl%peter@chubb.wattle.id.au> <49059FED.4030202@cs.columbia.edu> <1225125752.12673.79.camel@nimitz> <4905F648.4030402@cs.columbia.edu> <1225140705.5115.40.camel@enoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225140705.5115.40.camel@enoch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Helsley (matthltc@us.ibm.com):
> On Mon, 2008-10-27 at 13:11 -0400, Oren Laadan wrote:
> > Dave Hansen wrote:
> > > On Mon, 2008-10-27 at 07:03 -0400, Oren Laadan wrote:
> > >>> In our implementation, we simply refused to checkpoint setid
> > >> programs.
> > >>
> > >> True. And this works very well for HPC applications.
> > >>
> > >> However, it doesn't work so well for server applications, for
> > >> instance.
> > >>
> > >> Also, you could use file system snapshotting to ensure that the file
> > >> system view does not change, and still face the same issue.
> > >>
> > >> So I'm perfectly ok with deferring this discussion to a later time :)
> > > 
> > > Oren, is this a good place to stick a process_deny_checkpoint()?  Both
> > > so we refuse to checkpoint, and document this as something that has to
> > > be addressed later?
> > 
> > why refuse to checkpoint ?
> 
> 	If most setuid programs hold privileged resources for extended periods
> of time after dropping privileges then it seems like a good idea to
> refuse to checkpoint. Restart of those programs would be quite
> unreliable unless/until we find a nice solution.

I agree with Dave and Matt.  Let's assume that we have a setuid root
program which creates some resources then drops to username kooky.  If
you now checkpoint and restart that program, then a stupid restart will
either

	1. be done as user kooky and not be able to recreate the
	resources, fail.
	2. be done as user root and not drop uid back to kooky, unsafe.

For the earliest prototypes of c/r, I think saying that setuid an the
life of a container makes checkpoint impossible is the right thing to
do.

-serge
