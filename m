Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYEQPlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYEQPlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYEQPlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:41:35 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41394 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753701AbYEQPle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:41:34 -0400
Date: Sat, 17 May 2008 11:41:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start on
	X61s laptop
Message-ID: <20080517154131.GA7651@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	bugme-daemon@bugzilla.kernel.org
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, May 17, 2008 at 06:21:18AM -0700, Pallipadi, Venkatesh wrote:
> 
> Can you please send the complete dmesg after X failure, with patch here
> and debugpat boot option.
> http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2657.html

With debugpat enabled, the resulting dump that landed in
/var/log/messages was something like 1.6 megabytes, so it totally
overflowed the dmesg buffer.

I've created a Bugzilla attachment of the bzip'ed messages excerpt here:

http://bugzilla.kernel.org/attachment.cgi?id=16174&action=view

The patch above was only available in HTML-only mode (and I couldn't
find Ingo's patch on lkml.org, so I had to reconstruct it, and then
forward part it to 2.6.26-rc2-git5).  What I actually used can be
found here:

http://bugzilla.kernel.org/attachment.cgi?id=16173&action=view

I'm not sure this will be helpful for you, but this should be
completely trivial for you to reproduce; just use Ubuntu Gutsy on
Intel Video based laptop, with a 2.6.26-rc2-git4 or more recent
kernel, and watch it fail.  

For me, I'll just locally revert commit 1c12c4cf since otherwise X
becomes more-or-less unsuable.  (Getting used to 1024x768 after using
a 1600x1200 display is one thing; 800x600 is quite another, and the
performance using the VESA driver is quite abysmal.)

						- Ted
