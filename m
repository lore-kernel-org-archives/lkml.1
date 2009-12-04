Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbZLDRlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbZLDRlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932360AbZLDRlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:41:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:38540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340AbZLDRlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:41:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,343,1257148800"; 
   d="scan'208";a="575717038"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Pavel Machek <pavel@ucw.cz>, "Wang, Shane" <shane.wang@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Date: Fri, 4 Dec 2009 09:41:24 -0800
Subject: RE: [PATCH] intel_txt: add s3 userspace memory integrity
 verification
Thread-Topic: [PATCH] intel_txt: add s3 userspace memory integrity
 verification
Thread-Index: Acp1BR/4CJ5B7K/+QdymqijHH0NU6wAAszxg
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD552@orsmsx506.amr.corp.intel.com>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com>
 <20091004185801.GC1378@ucw.cz>
 <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com>
 <20091204081933.GE1540@ucw.cz>
 <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com>
 <20091204171333.GS18989@one.firstfloor.org>
In-Reply-To: <20091204171333.GS18989@one.firstfloor.org>
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

> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Friday, December 04, 2009 9:14 AM
>
> > "bad stuff" would be the execution of any code (or use of any data that affects execution)
> that was not verified by tboot.  As long as panic() is within the code ranges MAC'ed by tboot
> (see above), it would be covered.  Do you know of some panic() code paths that are outside of
> this?
>
> Not code path, but the code called by panic (console drivers, debuggers etc.)
> can well use data that is stored >4GB
>
> This can include structures with indirect pointers, like notifier chains.
>
> Notifier chains have a special checker than can check
> for <4GB, but there are other call vectors too.

Since, as you pointed out in a previous email, it is doubtful that there will be any user-visible output at this point, we can change this path to a tboot reset (which will give us some serial output at least).  Is it going to be similarly unsafe to do a printk()?

> > > > > checksummed by tboot, attacker may be able to hijack code execution
> > > > > and bypass your protection, no?
> > > > Yes, kernel code is audited by tboot before resume.
> > >
> > > So no, you did not audit do_suspend_lowlevel to make sure it does not
> > > follow function pointers. Bad.
> >
> > We aren't aware of any code or data used by the resume path that is outside of the tboot-
> MAC'ed regions above--if you can point out any then we will gladly address them.
>
> Code coverage is not enough, you need data coverage too.  If someone
> modifies kernel data it's typically easy to subvert code as a next step.

Agreed, which is why I said "code or data".  We'll take another look at the couple of fns that are within this path, but if you have any specific examples can you please post them.

>
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.
