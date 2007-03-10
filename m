Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbXCJJ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbXCJJ6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbXCJJ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:58:15 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:64487 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXCJJ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:58:14 -0500
Subject: Re: [PATCH] Complain about missing system calls.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andi Kleen <andi@firstfloor.org>
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
In-Reply-To: <20070309190051.GA20521@one.firstfloor.org>
References: <1173394873.3461.510.camel@pmac.infradead.org>
	 <p737itqbdnl.fsf@bingen.suse.de> <20070309163805.GV18564@lug-owl.de>
	 <20070309190051.GA20521@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Sat, 10 Mar 2007 10:58:13 +0100
Message-Id: <1173520693.7128.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 20:00 +0100, Andi Kleen wrote:
> > Not everybody has a simple indexed list of pointers :)  For example,
> > for vax-linux, we use a struct per syscall with the expected number of
> > on-stack longwords for the call.
> > 
> > So if something "new" is coming up, please keep in mind that it should
> > be flexible enough to represent that. :)
> 
> Are there plans to merge vax any time soon to mainline? 
> 
> Normally we don't care very much about out of tree code, especially
> if it adds complexity like this.
> 
> But I suspect s390 would need number of arguments anyways.

I can't quite follow that line of thought. Why does s390 need the number
of arguments? The wrapper of a compat system call implicitly knows how
many arguments a system calls to do the conversion. For a normal system
call we just call the function. Random example sys_read: the user space
loads the arguments to register %r2, %r3, %r4 and calls the system. The
register are not touched until sys_read is reached. Only sys_read cares
about the number of arguments in this case.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


