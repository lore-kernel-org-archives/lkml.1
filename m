Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbXJEKwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbXJEKwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJEKwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:52:16 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:44161 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbXJEKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:52:15 -0400
Date: Fri, 5 Oct 2007 11:52:09 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Steven J. Hill" <sjhill@realitydiluted.com>,
       veerasena reddy <veerasena_b@yahoo.co.in>,
       linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unresoved symbol _gp_disp
Message-ID: <20071005105209.GB1404@linux-mips.org>
References: <230962.51223.qm@web8408.mail.in.yahoo.com> <20071004173928.GA32033@real.realitydiluted.com> <p73k5q268d4.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73k5q268d4.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 08:29:59PM +0200, Andi Kleen wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: 04 Oct 2007 20:29:59 +0200
> To: "Steven J. Hill" <sjhill@realitydiluted.com>
> Cc: veerasena reddy <veerasena_b@yahoo.co.in>,
> 	linux-mips <linux-mips@linux-mips.org>,
> 	"linux-kernel.org" <linux-kernel@vger.kernel.org>
> Subject: Re: unresoved symbol _gp_disp
> Content-Type: text/plain; charset=us-ascii
> 
> "Steven J. Hill" <sjhill@realitydiluted.com> writes:
> 
> > > I have written a loadble module ( which gets complied
> > > along with kernel) which does some floating point
> > > operation.
> > >  
> > NO FLOATING POINT in the kernel PERIOD. Either use integer
> > operations, or redo your software architecture and do the
> > floating point in userspace.
> 
> You can use floating point; you just have to make sure to 
> save the FP context explicitely and disable preemption. Details
> on how to do this vary by architecture.
> 
> The problem is that FP code typically takes often a lot of CPU time
> and it is quite antisocial to disable preemption for a long time
> because that impacts real time latency for everybody.
> 
> Besides many uses can be relatively easily rewritten to fixed
> point.

He said he was using software floating point which from a kernel perspective
really just is integer stuff anyway.

Hardware floating point in a MIPS kernel would be require solving a few
interesting problems; the kernel floating point assist software is only
designed to support userspace.  Or alternativle well written FP code
that avoids all the corner cases which would normally be handled by the
kernel fp software.

The biggest argument against floating point use in the kernel is that most
of the time it's an indicator for poor division of work between kernel
and userspace.

  Ralf
