Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbZLDRNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbZLDRNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZLDRNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:13:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39829 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbZLDRN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:13:29 -0500
Date: Fri, 4 Dec 2009 18:13:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Wang, Shane" <shane.wang@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity verification
Message-ID: <20091204171333.GS18989@one.firstfloor.org>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com> <20091204081933.GE1540@ucw.cz> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> "bad stuff" would be the execution of any code (or use of any data that affects execution) that was not verified by tboot.  As long as panic() is within the code ranges MAC'ed by tboot (see above), it would be covered.  Do you know of some panic() code paths that are outside of this?

Not code path, but the code called by panic (console drivers, debuggers etc.)
can well use data that is stored >4GB

This can include structures with indirect pointers, like notifier chains.

Notifier chains have a special checker than can check
for <4GB, but there are other call vectors too.

> > > > checksummed by tboot, attacker may be able to hijack code execution
> > > > and bypass your protection, no?
> > > Yes, kernel code is audited by tboot before resume.
> >
> > So no, you did not audit do_suspend_lowlevel to make sure it does not
> > follow function pointers. Bad.
> 
> We aren't aware of any code or data used by the resume path that is outside of the tboot-MAC'ed regions above--if you can point out any then we will gladly address them.

Code coverage is not enough, you need data coverage too.  If someone 
modifies kernel data it's typically easy to subvert code as a next step.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
