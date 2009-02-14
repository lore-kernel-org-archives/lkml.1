Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZBNMxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZBNMxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 07:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZBNMxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 07:53:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52263 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZBNMxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 07:53:21 -0500
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org>
	<49815BF6.7060402@jp.fujitsu.com>
	<200902131129.09523.jbarnes@virtuousgeek.org>
	<m11vu1wtk6.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 14 Feb 2009 04:53:31 -0800
In-Reply-To: <m11vu1wtk6.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Fri\, 13 Feb 2009 20\:06\:49 -0800")
Message-ID: <m1ab8p89is.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesse Barnes <jbarnes@virtuousgeek.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And on the big gotcha's I have found one more I am tracking.

I am seeing pci bridges with a NULL pointer for the subordinate bus.
Earlier I had thought that this was a symptom of the double remove
but I have been able to reproduce it without that.

On just a little bit deeper investigation it looks like the cases
are dying are all coming when the nested bridge reappears.

Which is wrong on so many levels as I am toggle power to the outer
slot, so the nested bridge should not even exist at that time.  Ugh.
More tracing to for me on that one.

watch -n1 lspci -t seems like a good way to exacerbate races, when performing
hotplug tests.

Eric
