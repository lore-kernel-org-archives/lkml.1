Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZJ0SHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZJ0SHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbZJ0SHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:07:35 -0400
Received: from THUNK.ORG ([69.25.196.29]:58457 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbZJ0SHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:07:34 -0400
Date: Tue, 27 Oct 2009 14:07:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091027180718.GC7915@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	"Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jeff Garzik <jeff@garzik.org>,
	Robert Richter <robert.richter@amd.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jean Delvare <khali@linux-fr.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu> <57C9024A16AD2D4C97DC78E552063EA3E33D0A53@orsmsx505.amr.corp.intel.com> <20091026052118.GB13941@mit.edu> <4AE5E415.801@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE5E415.801@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 07:01:57PM +0100, Stefan Richter wrote:
> > Suppose I update the 40th patch of a 50th patch series to add check
> > for kmalloc() returning NULL that had been inadvertently left out, or
> > some other error checking is added.  Or suppose I add a new tracepoint
> > definition to a 50 patch series.
> 
> ...are bad examples in the context of linux-next, IMO.  A missing
> allocation failure check or a missing tracepoint don't break
> bisectability.  So why discard this history?  (It was already published
> in a release preview.)

There are multiple issues for rewinding patches.  One is to avoid
breaking bisectability.  Other is to keep related changes in
functionality in a single place.  2-3 years for now, does anyone
really care about retaining development history?  In the human memory,
one of the most important parts of long-term memory formation is
*forgetting*; that is, editing down everything that happened down to
the most cogent and importants bits of history.  This is what is
disrupted when people don't get enough sleep.

Similarly, there is absolutely no point in preserving the v1, v2, v3,
v4... versions of patches that appeared in LKML in Linus's git tree
--- surely people agree that's true?  And if something is being
maintained in quilt, and there are v1, v2, v3, v4 versions of a patch,
there's no reason why we should put it in git, right?  So if it's in a
rewinding git branch, such as what happens in the pu branch in git
development, the history isn't preserved either ---- and that's O.K.

	     	 	       		 	- Ted
