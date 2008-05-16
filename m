Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYEPDk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYEPDk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 23:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYEPDkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 23:40:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40304 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYEPDkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 23:40:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	<20080513053408.GA5870@redhat.com>
	<1210730266.23707.50.camel@caritas-dev.intel.com>
	<20080514025607.GA19944@redhat.com>
	<1210736275.23707.62.camel@caritas-dev.intel.com>
	<m1lk2c4l4i.fsf@frodo.ebiederm.org>
	<1210827473.23707.133.camel@caritas-dev.intel.com>
	<m1lk2bs970.fsf@frodo.ebiederm.org>
	<1210902114.23707.156.camel@caritas-dev.intel.com>
	<m14p8zgf43.fsf@frodo.ebiederm.org>
	<1210906575.23707.189.camel@caritas-dev.intel.com>
Date: Thu, 15 May 2008 20:33:41 -0700
In-Reply-To: <1210906575.23707.189.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Fri, 16 May 2008 10:56:15 +0800")
Message-ID: <m1iqxegbxm.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Huang, Ying" <ying.huang@intel.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0743]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec multi-stage load
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:


> I think it is reasonable to enable jumping back and forth more than one
> time.

I'm not opposed.  I just don't understand the utility yet.

> So the following should be possible:
>
> 1. Jump from A to B (actually jump to purgatory, trigger the boot of B)
> 2. Jump from B to A
> 3. Jump from A to B again (jump to the kexec_jump_back_entry of B)
                      (And we go through purgatory which remembers
                       the kexec_jump_back_entry of B)
> 4. Jump from B to A
> ...
>
> So it should be possible to get the re-entry point of kernel B in
> kexec_jump_back_entry of kernel A too. So I think in
> kexec_jump_back_entry, the caller's stack should be checked to get
> re-entry point of peer. And the stack state is different depend on where
> come from, from relocate_new_kernel() or return.

Yes.

Any conditional logic needs to be in purgatory or a similar trampoline.

Eric
