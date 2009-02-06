Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZBFBLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZBFBLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZBFBLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:11:46 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52763 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZBFBLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:11:46 -0500
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>
References: <498ADFE3.9020907@vmware.com>
	<1233856988.4286.83.camel@localhost.localdomain>
	<498B5ADE.3090602@vmware.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 05 Feb 2009 17:11:41 -0800
In-Reply-To: <498B5ADE.3090602@vmware.com> (Thomas Hellstrom's message of "Thu\, 05 Feb 2009 22\:32\:14 +0100")
Message-ID: <m1tz78pdwy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: thellstrom@vmware.com, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Hellstrom <thellstrom@vmware.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: 2.6.29 pat issue
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellstrom <thellstrom@vmware.com> writes:


> Indeed, it's crucial to keep the mappings consistent, but failure to do so is a
> kernel driver bug, it should never be the result of invalid user data.

It easily can be.  Think of an X server mmaping frame buffers. Or other
device bars.

> There are other more common kernel bugs that can be even worse and hang / crash
> the system. For example using uninitialized spinlocks, writing to kfreed memory
> etc. There is code in the kernel to detect these as well, but this code is
> behind debug defines.

There are cpu errata on almost every cpu in existence that come into play
if you have the cacheabilty attributes wrong on a page.  CPUs have been known
to do very weird things when you hit those errata.  At the best of it you
are no longer running on a deterministic machine, at the worst of it you
crash the cpu.

> IMHO checking each vm_insert_pfn() for caching attribute correctness is not
> something that should be enabled by default, due to the CPU overhead. Production
> drivers should never violate this.

If it is a problem the implementation should become more efficient.  Userspace
as well as drivers can generate these mappings so even with a perfect driver
you cannot guarantee that someone else does not have that area of memory
mapped differently.

Eric
