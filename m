Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXCAA2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXCAA2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932839AbXCAA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:28:34 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:59495 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932835AbXCAA2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:28:33 -0500
Date: Wed, 28 Feb 2007 16:27:58 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, ak@suse.de, tony.luck@intel.com,
       William Cohen <wcohen@redhat.com>
Subject: Re: debug registers and fork
Message-ID: <20070301002758.GF23543@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070228212510.1E213180067@magilla.sf.frob.com> <Pine.LNX.4.44L0.0702281847330.24215-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0702281847330.24215-100000@netrider.rowland.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

On Wed, Feb 28, 2007 at 07:01:17PM -0500, Alan Stern wrote:
> On Wed, 28 Feb 2007, Roland McGrath wrote:
> 
> > It is true that debug registers are inherited by fork and clone.
> > I am 99% sure that this was never specifically intended, but it
> > has been this way for a long time (since 2.4 at least).  It's an
> > implicit consequence of the do_fork implementation style, which
> > does a blind copy of the whole task_struct and then explicitly
> > reinitializes some individual fields.  I suppose this has some
> > benefit or other, but it is very prone to new pieces of state
> > getting implicitly copied without the person adding that new state
> > ever consciously deciding what its inheritance semantics should be.
> > 
> > Alan Stern is working on a revamp of the x86 debug register
> > support.  This is a fine opportunity to clean this area up and
> > decide positively what the semantics ought to be.
> 
> Absolutely.  Right now I just have a placeholder function with a note
> about checking for CLONE_PTRACE.  The cleanest solution, far and away,
> would be to have the child process inherit no breakpoints and no debug
> register values.
> 
I agree and that is how we have it on IA-64. With debugging, there is
always another process involved and no matter what I think it needs to 
be aware of the new child. I don't think autoamtic inheritance is good.
It should always be trigger by the controlling process (e.g., debugger).
There is enough support in ptrace to catch the fork/vfork/pthread_create
and decide what to do.  This is how I have coded perfmon so that hardware
performance counters are never automatically inherited.

-- 
-Stephane
