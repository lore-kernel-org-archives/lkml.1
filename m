Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYHKNxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYHKNxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYHKNwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:52:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYHKNww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:52:52 -0400
Date: Mon, 11 Aug 2008 09:51:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -v2 7/8] kexec jump: ftrace_enabled_save/restore
Message-ID: <20080811135136.GD28030@redhat.com>
References: <1218178368.22039.80.camel@caritas-dev.intel.com> <20080808141700.GF3840@redhat.com> <alpine.DEB.1.10.0808081026240.22796@gandalf.stny.rr.com> <1218417741.30464.23.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218417741.30464.23.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 09:22:21AM +0800, Huang Ying wrote:
> Hi, Steven,
> 
> On Fri, 2008-08-08 at 10:30 -0400, Steven Rostedt wrote:
> [...]
> > The only problem with this approach is what happens if the user changes 
> > the enabled in between these two calls. This would make ftrace 
> > inconsistent.
> > 
> > I have a patch from the -rt tree that handles what you want. It is 
> > attached below. Not sure how well it will apply to mainline.
> > 
> > I really need to go through the rt patch set and start submitting a bunch 
> > of clean-up/fixes to mainline. We've been meaning to do it, just have been 
> > distracted :-(
> 
> Your version is better in general sense. Thank you very much!
> 
> But in this specific situation of kexec/kjump. The execution environment
> is that other CPUs are disabled, local irq is disabled, and it is not
> permitted to switch to other process. But it is safe and sufficient to
> use non-locked version here.
> 
> So to satisfy both demands, I think it is better to provide both
> version, locked and non-locked. What do you think about that?
> 

Huang,

So you want to use a non-locked version from optimization point of view?
So that we don't end up taking and release a lock?

Thanks
Vivek
