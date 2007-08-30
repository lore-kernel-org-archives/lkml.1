Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbXH3MNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbXH3MNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 08:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXH3MNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 08:13:32 -0400
Received: from THUNK.ORG ([69.25.196.29]:58982 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbXH3MNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 08:13:31 -0400
Date: Thu, 30 Aug 2007 08:13:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Message-ID: <20070830121305.GB10160@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <20070828230459.GA15937@infradead.org> <m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com> <46D4CC81.4060400@zytor.com> <m1d4x7aysz.fsf@ebiederm.dsl.xmission.com> <20070829114604.242b976c@the-village.bc.nu> <m1absa5kid.fsf@ebiederm.dsl.xmission.com> <46D5ACA1.3090503@zytor.com> <m18x7u4154.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18x7u4154.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 01:00:07PM -0600, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > Eric W. Biederman wrote:
> >>
> >> My hypothesis.  No one cares now.
> >>
> >> My observation. The way we have been maintaining the binary sysctl
> >> side of things using it is asking for your application to be broken in
> >> subtle and nasty ways.
> >>
> >
> > I suspect the right thing to do is simply to make a list of the supported binary
> > sysctls, and automatically verify those numbers.  Doing that would alleviate
> > these concerns, wouldn't break anything, and isn't really that hard to do.
> 
> Well the list is currently 1200 lines long, with wild cards in it.
> See sysctl_check.c in the -mm tree.  I think I have finally found
> all of the binary sysctl numbers that are currently in use but I may
> have missed something.  Although that can probably be trimmed a bit
> now that a number of those sysctls have been identified as impossibly
> and always broken

It's not hard to do read-side, right?  Take the list of sysctl's, and
create a program which reads it via the binary interface and the /proc
interface, and verify they are the same.  

Testing write-side, where we have to worry about permission tests,
making sure the correctr value is set, locking issues, etc., is
admittedly more difficult.  My guess though many programs/libraries
are reading from the sysctl interface than writing to it.

    	    	     	    	      	   - Ted
