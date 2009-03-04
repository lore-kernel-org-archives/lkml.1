Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZCDOxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZCDOxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbZCDOwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:52:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43248 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZCDOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:52:52 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Mar 2009 06:52:39 -0800
In-Reply-To: <1235410082-5016-1-git-send-email-matthew@wil.cx> (Matthew Wilcox's message of "Mon\, 23 Feb 2009 12\:27\:56 -0500")
Message-ID: <m17i35z6fc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: matthew@wil.cx, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Wilcox <matthew@wil.cx>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Support for multiple MSI
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> Currently, Linux supports multiple MSI-X interrupts per device, but only
> a single MSI interrupt.  This patch series adds support to the generic
> PCI code for supporting multiple MSI interrupts.  Architectures will
> need to add support for multiple MSIs, and I have a patch to do that for
> x86 (which needs some more work).  Getting this patch series in first
> is important so we can start supporting this interface in drivers and
> architectures independently.

Do we have any benchmarks anywhere that show that multiple msi support
gains us something?

The requirement to allocate a contiguous block of vector numbers worries
me for the x86 implementation.  I don't like the idea of having to deal
with allocations that can fail because of fragmentation.

The fact that we also can not honor the irq affinity properly for multiple
msi also disturbs me.

At a quick skim your patchset is only the generic code without a single
architecture specific implementation so it appears you have not done the
hard work on figuring out how to deal with multiple msi in the real
world.

Given that msi-x does not have any of these issues without data to say
that there is a true gain in supporting multi-msi I don't see the point
of supporting it.

Eric
