Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbXF0Crd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbXF0Crd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbXF0CrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:47:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755014AbXF0CrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:47:21 -0400
Date: Tue, 26 Jun 2007 19:47:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Johansen <jjohansen@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-Id: <20070626194700.5b0ff477.akpm@linux-foundation.org>
In-Reply-To: <20070627022403.GB14656@suse.de>
References: <20070626230756.519733902@suse.de>
	<20070626165202.bfe8e6df.akpm@linux-foundation.org>
	<20070627022403.GB14656@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 19:24:03 -0700 John Johansen <jjohansen@suse.de> wrote:

> > 
> > so...  where do we stand with this?  Fundamental, irreconcilable
> > differences over the use of pathname-based security?
> > 
> There certainly seems to be some differences of opinion over the use
> of pathname-based-security.

I was refreshed to have not been cc'ed on a lkml thread for once.  I guess
it couldn't last.

Do you agree with the "irreconcilable" part?  I think I do.

I suspect that we're at the stage of having to decide between

a) set aside the technical issues and grudgingly merge this stuff as a
   service to Suse and to their users (both of which entities are very
   important to us) and leave it all as an object lesson in
   how-not-to-develop-kernel-features.

   Minimisation of the impact on the rest of the kernel is of course
   very important here.

versus

b) leave it out and require that Suse wear the permanent cost and
   quality impact of maintaining it out-of-tree.  It will still be an
   object lesson in how-not-to-develop-kernel-features.

Sigh.  Please don't put us in this position again.  Get stuff upstream
before shipping it to customers, OK?  It ain't rocket science.

> > Are there any other sticking points?
> > 
> > 
> The conditional passing of the vfsmnt mount in the vfs, as done in this
> patch series, has received a NAK.  This problem results from NFS passing
> a NULL nameidata into the vfs.  We have a second patch series that we
> have posted for discussion that addresses this by splitting the nameidata
> struct.
> Message-Id: <20070626231510.883881222@suse.de>
> Subject: [RFD 0/4] AppArmor - Don't pass NULL nameidata to
> vfs_create/lookup/permission IOPs
> 
> other issues that have been raised are:
> - AppArmor does not currently mediate IPC and network communications.
>   Mediation of these is a wip
> - the use of d_path to generate the pathname used for mediation when a
>   file is opened.
>   - Generating the pathname using a reverse walk is considered ugly
>   - A buffer is alloced to store the generated path name.
>   - The  buffer size has a configurable upper limit which will cause
>     opens to fail if the pathname length exceeds this limit.  This
>     is a fail closed behavior.
>   - there have been some concerns expressed about the performance
>     of this approach
>   We are evaluating our options on how best to address this issue.

OK, useful summary, thanks.  I'd encourage you to proceed apace.
