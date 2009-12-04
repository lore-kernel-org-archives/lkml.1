Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZLDUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZLDUJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZLDUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:09:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60191 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbZLDUJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:09:30 -0500
Date: Fri, 4 Dec 2009 21:09:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@ucw.cz>,
       "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Message-ID: <20091204200933.GA741@basil.fritz.box>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com> <20091204081933.GE1540@ucw.cz> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com> <20091204171333.GS18989@one.firstfloor.org> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD552@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD552@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 09:41:24AM -0800, Cihula, Joseph wrote:
> > From: Andi Kleen [mailto:andi@firstfloor.org]
> > Sent: Friday, December 04, 2009 9:14 AM
> >
> > > "bad stuff" would be the execution of any code (or use of any data that affects execution)
> > that was not verified by tboot.  As long as panic() is within the code ranges MAC'ed by tboot
> > (see above), it would be covered.  Do you know of some panic() code paths that are outside of
> > this?
> >
> > Not code path, but the code called by panic (console drivers, debuggers etc.)
> > can well use data that is stored >4GB
> >
> > This can include structures with indirect pointers, like notifier chains.
> >
> > Notifier chains have a special checker than can check
> > for <4GB, but there are other call vectors too.
> 
> Since, as you pointed out in a previous email, it is doubtful that there will be any user-visible output at this point, we can change this path to a tboot reset (which will give us some serial output at least).  Is it going to be similarly unsafe to do a printk()?

Yes printk is similarly unsafe. It calls all the console machinery,
which has a lot of data.

Perhaps early_printk(), that is relatively self contained, but doesn't
always work.

Of course you would need to have a timeout before reset, and at this point the
delay loops are not calibrated yet, so you don't know how to wait.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
