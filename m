Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZAONlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZAONlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759824AbZAONk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:40:56 -0500
Received: from thunk.org ([69.25.196.29]:50323 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760491AbZAONkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:40:55 -0500
Date: Thu, 15 Jan 2009 08:40:47 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>, ccache@lists.samba.org,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090115134047.GB30522@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Beulich <jbeulich@novell.com>,
	Peter Zijlstra <peterz@infradead.org>, ccache@lists.samba.org,
	Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <1231953379.14825.29.camel@laptop> <496F0BC2.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F0BC2.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 09:11:14AM +0000, Jan Beulich wrote:
> >>> Peter Zijlstra <peterz@infradead.org> 14.01.09 18:16 >>>
> >So what's the current status on this, could we get it reverted ASAP or
> >add that CONFIG_ switch (default N)?
> >
> >Leaving the build system broken for so long just isn't cool.
> 
> It is my understanding that Sam was looking at doing a partial revert first.
> If that doesn't work out, doing the CONFIG_* thing would be pretty trivial
> (I merged it into my local patch, and hence would simply have to extract it).

I just have a local branch, "emergency-fixes" which just reverts
commits ad7a953c and 9bb48247, which I pull in before doing full
builds.  

You can also work around the bug by disabling CONFIG_MODVERSIONS; one
of my build configurations has almost no modules at all but it still
had CONFIG_MODVERSIONS disabled, so for my sniff tests build of
mainline where I don't want to pull in the emergency-fixes branch,
I've also dealt with the situation by disabling CONFIG_MODVERSIONS.

These are both hacks, but they do work around the problem...

      	       	      	       	       - Ted
