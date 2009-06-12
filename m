Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbZFLRzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbZFLRzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZFLRzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:55:37 -0400
Received: from THUNK.ORG ([69.25.196.29]:41992 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbZFLRzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:55:36 -0400
Date: Fri, 12 Jun 2009 13:55:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when
	feature is disabled
Message-ID: <20090612175518.GE6417@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Andi Kleen <andi@firstfloor.org>,
	"riel@redhat.com" <riel@redhat.com>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu> <20090612125741.GA6140@localhost> <20090612131754.GA32105@elte.hu> <20090612133352.GC6751@localhost> <20090612153620.GB23483@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612153620.GB23483@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 05:36:20PM +0200, Ingo Molnar wrote:
> > The data corruption has not caused real hurt yet, and can be 
> > isolated to prevent future accesses.  So it makes sense to just 
> > kill the impacted process(es).
> 
> Dunno, this just looks like a license to allow more crappy hardware, 
> hm? I'm all for _logging_ errors, but hwpoison is not about that: it 
> is about allowing the hardware to limp along in 'enterprise' setups, 
> with a (false looking) 'guarantee' that everything is fine.

This should be tunable; in some cases, logging it is the right thing
to do; I imagine that in the case of the desktop OS, the user would
appreciate being given *some* chance to save the document he or she
has spent the past hour working on before the system goes down "hard
and fast".

In other cases, the sysadmin is using a high-availability setup in an
enterprise deployment, and there he or she would want the system to
immediately shutdown so the hot standby can take over.

	    	     	    		    	 - Ted
