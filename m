Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbZCFSiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbZCFSiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZCFSi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:38:26 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35483 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbZCFSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:38:25 -0500
Date: Fri, 6 Mar 2009 12:30:55 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <legoater@free.fr>
Cc: Greg Kurz <gkurz@fr.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090306183055.GA6729@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel> <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain> <1236288427.22399.122.camel@nimitz> <20090305220044.GA2819@x200.localdomain> <1236352121.5732.80.camel@bahia> <20090306153549.GA898@us.ibm.com> <49B15F35.2010909@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B15F35.2010909@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (legoater@free.fr):
> Serge E. Hallyn wrote:
> > Quoting Greg Kurz (gkurz@fr.ibm.com):
> >> On Fri, 2009-03-06 at 01:00 +0300, Alexey Dobriyan wrote:
> >>> On Thu, Mar 05, 2009 at 01:27:07PM -0800, Dave Hansen wrote:
> >>>>> Imagine, unsupported file is opened between userspace checks
> >>>>> for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
> >>>>> and whatever, you stil have to do all the checks inside checkpoint(2).
> >>>> Alexey, we have two problems here.  I completely agree that we have to
> >>>> do complete and thorough checks of each file descriptor at
> >>>> sys_checkpoint().  Any checks made at other times should not be trusted.
> >>>>
> >>>> The other side is what Ingo has been asking for.  How do we *know* when
> >>>> we are checkpointable *before* we call (and without calling)
> >>> This "without calling checkpoint(2)" results in much complications
> >>> as demonstrated.
> >>>
> >>> task_struct and file are not like other structures because they are exposed
> >>> in /proc. For PROC_FS=n kernels, one can't even check.
> >>>
> >>> You can do checkpoint(2) without actual dump. You pass, you're most
> >>> certainly checkpointable (with inevitable race condition in mind).
> >>>
> >> Ahhh thank you very much Alexey ! I wanted to explain this to Dave a few
> >> monthes ago but I failed... probably because of my poor English skills.
> >>
> >> https://lists.linux-foundation.org/pipermail/containers/2008-October/013549.html
> >>
> >> Why would we add checking all over the place when it MUST be done on the
> >> sys_checkpoint() path ? The checkpoint(2) dry-run is definitely the way
> >> to go.
> > 
> > I'm sure Dave understood that this was possible :)
> > 
> > But what you and Alexey are proposing does not and cannot fullfill
> > Ingo's requirement.
> 
> And if Ingo's requirement is fulfilled, would any C/R patchset be acceptable ?

Yup, no matter how hideous  :)  Ok not really.

But the point was that it wasn't Dave not understanding Alexey's
suggestion, but Greg not understanding Ingo's.  If you think Ingo's
goal isn't worthwhile or achievable, then argue that (as I am), don't
keep elaborating on something we all agree will be needed (Alexey's
suggestion or some other way of doing a true may-be-checkpointed test).

-serge
