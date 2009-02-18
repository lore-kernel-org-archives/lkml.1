Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZBRIrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZBRIrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZBRIqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:46:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38842 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZBRIqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:46:53 -0500
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org>
	<49815BF6.7060402@jp.fujitsu.com>
	<200902131129.09523.jbarnes@virtuousgeek.org>
	<m11vu1wtk6.fsf@fess.ebiederm.org> <49991D3A.7090001@jp.fujitsu.com>
	<m1mycktw5t.fsf@fess.ebiederm.org> <499BB4EB.6020602@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Feb 2009 00:47:10 -0800
In-Reply-To: <499BB4EB.6020602@jp.fujitsu.com> (Kenji Kaneshige's message of "Wed\, 18 Feb 2009 16\:12\:43 +0900")
Message-ID: <m1hc2s5dyp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kaneshige.kenji@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.0 XMPhish11 BODY: Confirm email account/addy
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0143]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:

> In the current pciehp implementation, minimum resources enough to
> enable devices under the bridge are assigned when P2P bridge is
> hot-added. My concern is that enough resources are NOT assigned to
> the bridge if an additional slot is empty. As a result, hot-add
> adapter card on the additional slot won't work because of resource
> shortage.

It is a good concern.  Right now I know I won't need a bus number
but you are quite right the mmio and iospace may be a problem.

My preliminary test case doesn't cover that so I will look and
confirm it is a problem I need to address.

>> kobject_name is not initialized, and slot_name(p_slot) calls
>> hoptlug_slot_name which calls pci_slot_name which kobj_name. 
>> It looks like this problem was introduced in commit 
>> e1acb24f059defdaa0264e925f19cc21b0a3e592
>
> Thank your for the information. I understood what is happening.
> This needs to be fixed. But, as I mentioned before, I think
> software notification mechanism should be initialized before
> sysfs entries are created. I'll consider alternative fix.

Reasonable.  I haven't had the need nor gotten brave enough to
support those sysfs entries in my minimal driver.

Eric
