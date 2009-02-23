Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZBWLRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZBWLRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZBWLRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:17:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57116 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZBWLRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:17:04 -0500
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org>
	<49815BF6.7060402@jp.fujitsu.com>
	<200902131129.09523.jbarnes@virtuousgeek.org>
	<m11vu1wtk6.fsf@fess.ebiederm.org> <49991D3A.7090001@jp.fujitsu.com>
	<m1mycktw5t.fsf@fess.ebiederm.org> <499BB4EB.6020602@jp.fujitsu.com>
	<m1hc2s5dyp.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Feb 2009 03:17:32 -0800
In-Reply-To: <m1hc2s5dyp.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Wed\, 18 Feb 2009 00\:47\:10 -0800")
Message-ID: <m17i3h5rn7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kaneshige.kenji@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.0 XMPhish11 BODY: Confirm email account/addy
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1204]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:
>
>> In the current pciehp implementation, minimum resources enough to
>> enable devices under the bridge are assigned when P2P bridge is
>> hot-added. My concern is that enough resources are NOT assigned to
>> the bridge if an additional slot is empty. As a result, hot-add
>> adapter card on the additional slot won't work because of resource
>> shortage.
>
> It is a good concern.  Right now I know I won't need a bus number
> but you are quite right the mmio and iospace may be a problem.
>
> My preliminary test case doesn't cover that so I will look and
> confirm it is a problem I need to address.

Tested.  I do have a problem with not assigning resources to new
bridges.

My plan to handle this currently is to do what the pci code does for
cardbus without resources.  To give them a fixed sized resource
assignment without looking downstream from the bridge.  The code
looks simple, and we have existing practice so it should not be too
bad to deal with.

Eric
