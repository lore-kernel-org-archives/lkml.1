Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYEPDBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYEPDBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 23:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbYEPDAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 23:00:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45808 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbYEPDAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 23:00:18 -0400
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
	<20080516020043.GC6926@redhat.com>
	<1210904374.23707.178.camel@caritas-dev.intel.com>
Date: Thu, 15 May 2008 19:55:44 -0700
In-Reply-To: <1210904374.23707.178.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Fri, 16 May 2008 10:19:34 +0800")
Message-ID: <m1tzgzez4f.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Huang, Ying" <ying.huang@intel.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0107]
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

> The disadvantage of this solution is that kernel B must know it is
> original kernel (A) or kexeced kernel (B). Different code should be used
> by kernel A and kernel B. And after jump from A to B, jump from B to A,
> when jump from A to B again, kernel A must use different code from the
> first time.

I don't know what the case is for keeping two kernels in memory and switching
between them.

I suspect a small piece of trampoline code between the two kernels could
handle the case. (i.e. purgatory pays attention).

That is a fundamental aspect of the design.  A general purpose infrastructure
with trampoline code to adapt it to whatever situation comes up.

Eric
