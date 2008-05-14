Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbYENVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbYENVuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYENVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:50:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48182 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYENVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:50:25 -0400
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
Date: Wed, 14 May 2008 14:43:41 -0700
In-Reply-To: <1210736275.23707.62.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Wed, 14 May 2008 11:37:55 +0800")
Message-ID: <m1lk2c4l4i.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: "Huang, Ying" <ying.huang@intel.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec multi-stage load
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

>> So, IMHO, for first simple implementation, we don't have to pass around
>> any data between kernels except entry point. (Please correct me if I am 
>> wrong). Lets get that implementation in first and then we can get rest
>> of the pieces in place.
>
> Yes. Kernel entry/re-entry point is the only information need to be
> communicated between kernels for just switching between them. So we can
> focus on kexec jump patch firstly.

Then as a preliminary design let's plan on this.

- Pass the rentry point as the return address (using the C ABI).
  We may want to load the stack pointer etc so we can act as
  a direct entry point for new code.

- Look at passing a pointer to the mapping of pages that the kexec
  trampoline uses in arg1 of the C ABI.  Largely the format is defacto
  fixed anyway because we need to pass the structure from C to
  assembly.

Using the standard C ABI makes things much it much easier to pick
a calling convention, and to document it.

Eric
