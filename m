Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZLDWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZLDWUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZLDWUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:20:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59721 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbZLDWUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:20:45 -0500
Date: Fri, 4 Dec 2009 23:20:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: "Wang, Shane" <shane.wang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
 verification
Message-ID: <20091204222045.GE32314@elf.ucw.cz>
References: <4B18D26B.4040500@intel.com>
 <20091204082927.GF1540@ucw.cz>
 <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4DC@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4DC@orsmsx506.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +
> > > +   ret = tboot_pre_stack_switch();
> > > +   if (!ret) {
> > > +           tboot_switch_stack_call(tboot_do_suspend_lowlevel_call,
> > > +                                   (u64)new_stack_ptr);
> >
> > ...and here you add requirements to suspend_lowlevel that were not
> > there before. ("May not act on unchecksummed memory"), without
> > documenting them.
> 
> Really the only requirement is (as discussed in the previous thread) that it only use code and data within [_text, _end - _text]--do you think that this really needs to be called out?  do_suspend_lowlevel() is a very simple function that has just the one (resume path) call to another simple function--it doesn't seem likely that it would violate this.
> 

Resume code is already pretty tricky, and you add yet another layer of
trickery. Yes, it needs to be properly documented.

And... how does it interact with restore_processor_state? I don't
think do_suspend_lowlevel is as simple as you think...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
