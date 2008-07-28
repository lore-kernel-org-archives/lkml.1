Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbYG1WxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbYG1WxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYG1Wwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:52:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58073 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYG1Wwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:52:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
References: <20080727234529.GM6175@verge.net.au>
	<20080728015117.GA12055@verge.net.au>
	<20080728024526.GB3334@verge.net.au>
	<20080728034007.GA30450@verge.net.au>
	<20080728211025.GA9985@redhat.com>
Date: Mon, 28 Jul 2008 15:47:41 -0700
In-Reply-To: <20080728211025.GA9985@redhat.com> (Vivek Goyal's message of
	"Mon, 28 Jul 2008 17:10:25 -0400")
Message-ID: <m1vdypfwxe.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/5] Move elfcorehdr_addr out of vmcore.c (Was: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr')
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Hi All,
>
> How does following series of patches look like. I have moved
> elfcorehdr_addr out of vmcore.c and pushed it to arch dependent section 
> of crash dump to make sure that it can be worked with even when
> CONFIG_PROC_VMCORE is disabled and CONFIG_CRASH_DUMP is enabled.
>
> I tested it on x86_64. Compile tested it on i386 and ppc64. ia64 and
> sh versions are completely untested.

Given the current state of the code:
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

To process a kernel crash dump we pass the kernel elfcorehdr option, so testing
to see if it was passed seems reasonable.

In general I think this method of handling the problems with kdump is
too brittle to live, but in the case of iommus we certainly need to do something
different, and unfortunately iommus were not common on x86 when the original code
was merged so we have not handled them well.

Eric
