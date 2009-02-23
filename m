Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZBWLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZBWLI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZBWLIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:08:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46841 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZBWLIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:08:17 -0500
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org>
	<49815BF6.7060402@jp.fujitsu.com>
	<200902131129.09523.jbarnes@virtuousgeek.org>
	<m11vu1wtk6.fsf@fess.ebiederm.org> <m1ab8p89is.fsf@fess.ebiederm.org>
	<m11vu183ti.fsf@fess.ebiederm.org> <49991D8C.1050705@jp.fujitsu.com>
	<m1y6w4u001.fsf@fess.ebiederm.org> <499BA141.2090403@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Feb 2009 03:08:44 -0800
In-Reply-To: <499BA141.2090403@jp.fujitsu.com> (Kenji Kaneshige's message of "Wed\, 18 Feb 2009 14\:48\:49 +0900")
Message-ID: <m1vdr15s1v.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kaneshige.kenji@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: marc.info]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0348]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:

> Ok, I understood what is happening. Could you try the following patch?
> It is currently in Jesse's linux-next.
>
> http://marc.info/?l=linux-pci&m=123364118418484&w=2
>
> BTW, I don't think surprise removal is well tested.

That patch should guarantee that we don't loop forever, and if we are
going to loop that looks like a reasonable way to handle it.

When I start working on what is the most maintainable way to implement
merge my hotplug driver work I will come back and test this.

At the moment it appears that it will at least suffer from detecting a
presence change event with a device showing up.  Before pci structure
for the device is removed.  I seem to recall some dead locks on the
pciehp work queue hotunplugging a hotplug driver as well.

Eric
