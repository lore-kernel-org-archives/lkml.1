Return-Path: <linux-kernel-owner+w=401wt.eu-S1751874AbZBQHX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbZBQHX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 02:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZBQHXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 02:23:17 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35408 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZBQHXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 02:23:17 -0500
Date: Tue, 17 Feb 2009 12:52:28 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
Subject: Re: RT scheduling and a way to make a process hang, unkillable
Message-ID: <20090217072228.GA15989@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop> <20090216103636.GC17355@linux.vnet.ibm.com> <f73f7ab80902161216j8690f05sf1103759cc932846@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab80902161216j8690f05sf1103759cc932846@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 03:16:25PM -0500, Kyle Moffett wrote:
> On Mon, Feb 16, 2009 at 5:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > On Sun, Feb 15, 2009 at 12:24:56PM +0100, Peter Zijlstra wrote:
> >> On Sat, 2009-02-14 at 16:51 -0800, Corey Hickey wrote:
> >> > The procedure is for a program to:
> >> > 1. run as root
> >> > 2. set SCHED_FIFO
> >> > 3. change UID to a user with no realtime CPU share allocated
> >>
> >> Hmm, setuid() should fail in that situation.
> >>
> >> /me goes peek at code.
> >>
> >> Can't find any code to make that happen, Dhaval didn't we fix that at
> >> one point?
> >
> > So after some searching around, I realized we did not. Does this help?
> > It fixes it on my system,
> >
> > --
> > sched: Don't allow setuid to succeed if the user does not have rt bandwidth
> 
> Erm, hrm, this reminds me of the old sendmail capabilities bug.  There
> are an awful lot of buggy binaries out there who assume that if they
> have uid 0 and they call setuid() that it cannot fail.  They then do
> all sorts of insecure operations, assuming that they have dropped to
> an unprivileged UID.  This one is especially bad because it could bite
> *any* program using setuid() which an admin happens to run with chrt.
> 

Would that not be a bug in the application itself and fixed there
itself? As Peter mentions there are other ways setuid can fail as well.

> Specifically, I personally think that:
>   *  Process is stuck and unkillable
> 
> is a much better result than:
>   *  Process runs arbitrary untrusted code with full-root privs in RT mode.
> 

thanks,
-- 
regards,
Dhaval
