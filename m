Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZHGWQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZHGWQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZHGWQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:16:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46345 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZHGWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:16:51 -0400
To: Bernhard Walle <bernhard.walle@gmx.de>
Cc: Amerigo Wang <amwang@redhat.com>, Neil Horman <nhorman@redhat.com>,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<m1eirqtmey.fsf@fess.ebiederm.org>
	<20090805140408.GJ7259@hmsreliant.think-freely.org>
	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>
	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>
	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>
	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com>
	<m1iqh1nxv3.fsf@fess.ebiederm.org> <4A7A9E54.60705@redhat.com>
	<m1iqgze740.fsf@fess.ebiederm.org> <4A7C9D48.3030405@gmx.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 07 Aug 2009 15:16:43 -0700
In-Reply-To: <4A7C9D48.3030405@gmx.de> (Bernhard Walle's message of "Fri\, 07 Aug 2009 23\:31\:52 +0200")
Message-ID: <m1tz0jmfqs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: bernhard.walle@gmx.de, kexec@lists.infradead.org, andi@firstfloor.org, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, nhorman@redhat.com, amwang@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernhard Walle <bernhard.walle@gmx.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 0/7] Implement crashkernel=auto
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bernhard.walle@gmx.de> writes:

> Eric W. Biederman schrieb:
>> 
>> With the current set of crashkernel= options we are asking the
>> distribution installer to perform magic.  Moving as much of this logic
>> into a normal init script for better maintenance is desirable.
>
> Not (necessarily) the installer but the program that configures kdump.
> system-config-kdump on Red Hat, YaST on SUSE.

Right.  Somehow I thought YaST was the installer my mistake.

>> Bernhard does that sound useful to you?
>
> I don't see any problems. I don't know how much effort is it to free
> already reserved crashkernel memory, but I guess it's not really
> complicated. 

Right.

> Maybe that "1/32" should be specified on the command line like
>
>
> 	crashkernel=>>5
>
> (for 1/32*system_memory == system_memory>>5), OTOH I have no real strong
> opinion.

The idea is for the system to give us as much as it can stand and
userspace gives the rest back.  The maximum memory any particular
kernel can stand to give up is a tractable kernel level problem, and
we can make it autotune like any other kernel tunable.  What a crash
kernel needs totally depends on the implementation.

Eric
