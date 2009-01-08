Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbZAHOqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbZAHOqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZAHOqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:46:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbZAHOqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:46:22 -0500
Date: Thu, 8 Jan 2009 15:46:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
Message-ID: <20090108144610.GC18120@elte.hu>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com> <20090107212912.e2903579.akpm@linux-foundation.org> <alpine.DEB.1.10.0901080917510.22642@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901080917510.22642@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 7 Jan 2009, Andrew Morton wrote:
> 
> > On Wed, 7 Jan 2009 23:58:39 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > >  kernel/trace/ring_buffer.c |    8 +++++++-
> > 
> > <looks>
> > 
> > heavens, what a lot of inlining.  Looks like something from 1997 :)
> > 
> > Prove me wrong!
> 
> I'm working on it ;-)

i really think that inlines in .c code are uninteresting. They are 
basically inserted randomly when a function starts out 'looking simple' - 
then are forgotten about when the function grows a bit.

They have some very mild documentation value ('look, this function is 
supposed to be simple'), but otherwise it just increases review noise. And 
latest GCC seems pretty ambivalent to their presence - so they dont help 
nor hurt in any direction.

So i think we can afford to enter the year 2009 and can stop bothering 
about [.c file] inlines ;-)

[ The only interesting inlines are the __always_inline instances - that's 
  where we _must_ have inlining for some subtle reason. But those should 
  almost never be used in .c code. ]

	Ingo
