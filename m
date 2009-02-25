Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbZBYEWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbZBYEWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbZBYEWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:22:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37890 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbZBYEWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:22:15 -0500
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1ocx5ve8o.fsf@fess.ebiederm.org>
	<200902201153.52683.rjw@sisk.pl> <m1r61s2znc.fsf_-_@fess.ebiederm.org>
	<200902241112.59203.jbarnes@virtuousgeek.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Feb 2009 20:22:44 -0800
In-Reply-To: <200902241112.59203.jbarnes@virtuousgeek.org> (Jesse Barnes's message of "Tue\, 24 Feb 2009 11\:12\:58 -0800")
Message-ID: <m1k57ftaaz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesse Barnes <jbarnes@virtuousgeek.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove (take 2)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> On Friday, February 20, 2009 8:16:07 pm Eric W. Biederman wrote:
>> pcie_port_device_remove currently calls the remove method of port
>> drivers twice.  Ouch!
>>
>> We are calling device_for_each_child multiple times for no apparent
>> reason.
>>
>> So make it simple. Place put_device and device_unregister into
>> remove_iter, and throw out the rest.  Only call device_for_each_child
>> once.
>>
>> The code is simpler and actually works!
>>
>> Changelog:
>> v2 rebase against the linux-next tree so I don't conflict with Rafael's
>>    irq work, and remove the irq handling cleanups as Rafael's patch already
>>    made them.
>
> Thanks for rebasing; it's queued up in my linux-next branch now.  If we really 
> need this in the stable kernel it'll be a bit painful, since some of these 
> structures have changed around a bit...

I don't think it is necessary for stable.  The pciehp still needs more
work, and if anyone of the other port drivers was being hotplugged I
expect someone would have noticed the bug and fixed it before now.

Eric
