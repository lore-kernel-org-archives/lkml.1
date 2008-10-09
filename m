Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYJISg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYJISg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYJISgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:36:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:8631 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbYJISgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:36:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,384,1220252400"; 
   d="scan'208";a="57502341"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted Execution Technologysupport for Linux - Overview
Date: Thu, 9 Oct 2008 11:35:56 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005B12CC8@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20081009182149.GE12507@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted Execution Technologysupport for Linux - Overview
Thread-Index: AckqO8YE+59hmHS0Ryat8bJqMU0JuQAAIdRw
References: <D936D925018D154694D8A362EEB0892005AC105B@orsmsx416.amr.corp.intel.com> <20081009125311.GD1623@ucw.cz> <20081009174427.GB6912@sequoia.sous-sol.org> <20081009175938.GA12507@elf.ucw.cz> <20081009181451.GD6912@sequoia.sous-sol.org> <20081009182149.GE12507@elf.ucw.cz>
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: "Pavel Machek" <pavel@suse.cz>, "Chris Wright" <chrisw@sous-sol.org>
Cc: <linux-kernel@vger.kernel.org>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 09 Oct 2008 18:36:48.0006 (UTC) FILETIME=[FCD68A60:01C92A3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Pavel Machek
> Sent: Thursday, October 09, 2008 11:22 AM
> 
> On Thu 2008-10-09 11:14:51, Chris Wright wrote:
> > * Pavel Machek (pavel@suse.cz) wrote:
> > > I have never used trusted boot and I'm not sure I want to. Why
> would I
> > > want to do that?
> >
> > So that you can reason that you've booted kernel/initrd that you
wanted
> > to (and have established a root of trust for follow-on, like Joe's
IMA
> > example), and in the case that you didn't (say bluepill), you have a
> > policy in place to handle it.
> 
> So like... instead of booting into rootkit it now will not boot at
> all?

The action taken when a policy fails to verify is configurable.  Some
users may prefer to hang the boot rather than boot a rootkit'ed kernel.
Those who don't can still get value from the fact that the PCRs will
indicate that this was not the previous (or known-good) kernel, if they
have sealed some data to the good values or if they are using
attestation (e.g. via a Trusted Network Connect (TNC)/NAC
infrastructure).

> > > You exit/reenter the trusted mode accross sleep... so any
guarantees
> > > "trusted" mode does are void, right?
> >
> > You exit from kernel to tboot on any shutdown, which handles the
proper
> > teardown of the measured env (meaning you also come back on via
tboot).
> > So things like saving tpm state, scrubbing secrets from memory, etc.
> 
> Aha, so instead sleep mode is useless because I'll have to remount all
> the crypto filesystems and restart all the apps...

Sleep mode works the same as it does today (caveat S4 issue which we
will fix), it just goes through the tboot code before putting the
platform HW into the appropriate state.  What this process is adding is
that on resume, tboot will get control from BIOS instead of the kernel.
Then tboot will re-launch the TXT environment before going back to the
kernel at the kernel's expected S3 resume vector.  The re-establishing
of the protected environment won't disrupt the subsequent kernel resume
process.

Joe
