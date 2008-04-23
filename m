Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYDWM54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYDWM54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYDWM5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:57:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32937 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYDWM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:57:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: yhlu.kernel@gmail.com
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <greg@kroah.com>,
       "David Miller" <davem@davemloft.net>, "Jeff Garzik" <jeff@garzik.org>,
       "linux-pci" <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
References: <200804222148.17530.yhlu.kernel@gmail.com>
Date: Wed, 23 Apr 2008 05:57:30 -0700
In-Reply-To: <200804222148.17530.yhlu.kernel@gmail.com> (Yinghai Lu's message
	of "Tue, 22 Apr 2008 21:48:16 -0700")
Message-ID: <m1prsgohj9.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel.send@gmail.com> writes:

> this change
>
> | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
> | Author: Prakash, Sathya <sathya.prakash@lsi.com>
> | Date:   Fri Mar 7 15:53:21 2008 +0530
> |
> |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
> |
> | This patch modifies the driver to enable MSI by default for all SAS chips.
> |
> |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> |
> cause kexec RHEL 5.1 kernel fail.
>
> root casue: the rhel 5.1 kernel still use INTx emulation.
> and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec
> path
>
> so try to call pci_disable_msi in shutdown patch

Ok this looks like a reasonable approach.

Could you please change how this is factored.
And implement a pci_shutdown_msi and a pci_shutdown_msix that
just performs the hardware state change.

Then have pci_disable_msi and pci_disable_msix call them?

That should be much easier to maintain then a adding a function
that takes a magic flag. 

That is the design of the shutdown interface and it seems to
work well.

Eric
