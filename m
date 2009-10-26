Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZJZExp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZJZExp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 00:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZJZExp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 00:53:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:13701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbZJZExo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 00:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,623,1249282800"; 
   d="scan'208";a="203486965"
From: "Luck, Tony" <tony.luck@intel.com>
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Oct 2009 21:53:41 -0700
Subject: RE: [RFC] to rebase or not to rebase on linux-next
Thread-Topic: [RFC] to rebase or not to rebase on linux-next
Thread-Index: AcpUgIZqATomcBPtRUeF28Mb0IqJ6gBc79yw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E33D0A53@orsmsx505.amr.corp.intel.com>
References: <20091022122042.e535d43c.sfr@canb.auug.org.au>
 <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org>
 <20091023123555.GA25366@elte.hu>
 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>
 <20091023134115.GD27097@elte.hu>
 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>
 <20091023191631.GA1879@elte.hu>
 <1256326512.26028.34.camel@gandalf.stny.rr.com>
 <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu>
In-Reply-To: <20091024080326.GA7461@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2) There are many legitimate reasons for "rewinding".  In addition to
> being able to add credit for tested-by and acked-by lines, sometimes
> patches are subtle.  More than once, patches have been sitting in the
> ext4 tree that have passed the XFSQA test, and thus have been "unit
> tested", but they still have bugs; in some cases, subtle bugs.  In
> some cases, bugs that cause data corruption.  In the case where the
> patches have hit linux-next, but the merge window hasn't opened yet, I
> prefer to fix the patch by mutating it, and rewinding the ext4 tree,
> instead of adding a fix later.  It makes it easier to cherry pick
> patches to the stable tree later, and it keeps the ext4 tree clean,
> and it has no downside in terms of linux-next --- see (1) above.

If the "rewind" is simply to add "signed-off-by" notations, update
commit comments (or code comments) ... then it does seem useful to
keep the commit chain anchored to the original commit, as the testing
that has been done is all still valid.

But as soon as you talk about fixing bugs ... then you ought to
just do a "rebase".  The code you are adding has changed, so it is
incorrect to preserve the illusion that these changes have had
extensive testing against the old commit base.  The code has changed,
so the testing clock gets reset to zero.

-Tony
