Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZA2QLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZA2QLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZA2QLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:11:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZA2QLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:11:36 -0500
Subject: Re: PFs on pages pinned with get_user_pages()
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200901291703.35463.frank.mehnert@sun.com>
References: <200901290905.10966.frank.mehnert@sun.com>
	 <200901291541.32618.frank.mehnert@sun.com>
	 <1233240757.4495.94.camel@laptop>
	 <200901291703.35463.frank.mehnert@sun.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 17:11:23 +0100
Message-Id: <1233245483.4495.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 17:03 +0100, Frank Mehnert wrote:
> On Thursday 29 January 2009, Peter Zijlstra wrote:
> > > > That aside, is there any reason you have to avoid scheduling? Otherwise
> > > > I would just allow so and be done with it.
> > >
> > > The reason is that our code expects that to ensure syncing of the CPU
> > > state with the saved state. I fear it is quite difficult to change
> > > that...
> >
> > Ah, is that what KVM uses the preempt notifiers for? Could you too?
> 
> Right, that could be an option.
> 
> We will try to change our code which is a big effort as we try
> to keep the code as unique as possible between the different
> hosts we support (Linux, Solaris, Windows, Mac OS X).
> 
> Just to be sure: There is no other option than disabling interrupts
> or calling disable_preemption() to prevent scheduling?

Thing is, lock_page() and down_read() require to be able to schedule(),
so there's no way around that.

So even if there was another way to disable scheduling, you'd still have
the same problem.

