Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbYB2VQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbYB2VQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYB2VQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:16:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbYB2VQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:16:45 -0500
Date: Fri, 29 Feb 2008 22:15:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Roskin <proski@gnu.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080229211513.GI27212@elte.hu>
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <1204304352.6767.21.camel@localhost> <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204313978.2316.8.camel@dv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Roskin <proski@gnu.org> wrote:

> I already know what USB folks will say.  They want proprietary drivers 
> to be in the userspace.  I doubt ndiswrapper will ever be ported to 
> the userspace.  It's much more likely that some other approach will be 
> used.

btw., what are the technical reasons why ndiswrapper cannot be done in 
userspace, much like the (wildly successful) FUSE concept?

what's the main hardware access method of ndiswrapper - only PIO, or 
mmio as well? In the former case, ioperm() should work, in the latter 
case, mmap()ing the device aperture should work.

Frankly, it would be a great approach for the following reason: it would 
be _far_ easier for people to write a proper free driver, if the NDIS 
driver was in user-space, in a nicely debuggable, traceable, observable 
environment. I dont really see what the technical difficulties there are 
here.

	Ingo
