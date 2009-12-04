Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbZLDUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbZLDUKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbZLDUKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:10:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41943 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbZLDUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:10:50 -0500
Date: Fri, 4 Dec 2009 21:10:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Message-ID: <20091204201056.GB741@basil.fritz.box>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com> <20091204081933.GE1540@ucw.cz> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com> <20091204171333.GS18989@one.firstfloor.org> <4B194CA1.3070106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B194CA1.3070106@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 09:53:37AM -0800, H. Peter Anvin wrote:
> On 12/04/2009 09:13 AM, Andi Kleen wrote:
> >>>
> >>> So no, you did not audit do_suspend_lowlevel to make sure it does not
> >>> follow function pointers. Bad.
> >>
> >> We aren't aware of any code or data used by the resume path that is outside of the tboot-MAC'ed regions above--if you can point out any then we will gladly address them.
> > 
> > Code coverage is not enough, you need data coverage too.  If someone 
> > modifies kernel data it's typically easy to subvert code as a next step.
> > 
> 
> The only function pointers that are invoked on the do_suspend_lowlevel
> path are some paravirt_crap pointers, but those are located inside
> kernel static data.

Was referring to panic(), like Pavel said.

It would be relatively easy to subvert something called by panic
that just jumps back to after the MAC checks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
