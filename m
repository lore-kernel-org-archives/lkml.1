Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319Ab0A3S5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0A3S5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956Ab0A3S5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:57:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:52766 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0A3S5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:57:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sa9CdURWgQvPtZjGMFSZhG51sTAO8+vJ/OSxtNjdbXM6Imi/Q3uKmgUMBWoUADqiBr
         IcTPixyFqG0TvlUWTgqcjeocOXEXaoiGFIj7iCGT+vqOLOtX7hd5N1VRxK6vDNqJ+K81
         Tq1Tk4fKygAuOZ7KICRTB345xKzYOXkw2ppTI=
Date: Sat, 30 Jan 2010 19:57:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lock dependency based tree report in perf lock
Message-ID: <20100130185736.GC5675@nowhere>
References: <20100129231723.GB5052@nowhere> <1264841188.24455.54.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264841188.24455.54.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 09:46:28AM +0100, Peter Zijlstra wrote:
> On Sat, 2010-01-30 at 00:17 +0100, Frederic Weisbecker wrote:
> > 
> > 
> > Anyway, that's just an idea, not trivial I must admit.
> 
> lockdep actually collects all this information, so writing it out isn't
> too hard.



Lockdep collects the theorical dependencies but not the practical
scenarios.

Say B and C depend on A, you'll get:

   A
  / \
 B   C

But nothing can tell you that if A is taken, B and C will always
be taken. You may have different scenarios based on this dependency,
which is not something that lockdep logs, right?

