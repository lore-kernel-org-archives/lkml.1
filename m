Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbZHFGOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbZHFGOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZHFGOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:14:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51417 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZHFGOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:14:15 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<m1eirqtmey.fsf@fess.ebiederm.org>
	<20090805140408.GJ7259@hmsreliant.think-freely.org>
	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>
	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>
	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 Aug 2009 23:14:10 -0700
In-Reply-To: <4A7A70E5.2010204@redhat.com> (Amerigo Wang's message of "Thu\, 06 Aug 2009 13\:57\:57 +0800")
Message-ID: <m1bpmtqxjh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, nhorman@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 0/7] Implement crashkernel=auto
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Eric W. Biederman wrote:
>> Amerigo Wang <amwang@redhat.com> writes:
>>
>>   
>>>> No the crashdump mechanism is useless because user space is already
>>>> broken and unusable.
>>>>       
>>> Again, why broken?
>>>     
>>
>> To get a stock stat drive by hand I had to list about 5 kernel modules
>> in the right magic order in /etc/kdump.conf
>>
>> Neither mount by label or mount by uuid when specified in /etc/kdump.conf
>> I had to hack mkdumprd to get an initrd that even finds the proper disk
>> to mount.
>>   
>
> You are saying that there is some difficulty to make a initrd for kdump, but I
> am sorry that I can't see any relations between this and my patch. What is your
> point here?

You are trying to make it easier for end users.

I am saying the problem is in user space.

I am saying also that the kernel doesn't have a clue what you are
going to load with kexec on panic to handle panics.  Maybe it is a
custom stand alone binary that only needs 5K.  So the kernel doesn't
have a clue what the right size to reserve.

I think if what you were proposing was part of some coherent story for
a complete implementation I would consider it more.  Instead this just
appears to be a reaction to how frustrating the user space
implementation is, and fixing things in the kernel instead of in user
space.

The fact that user space is broken to the point of usability on fedora
simply reinforces the point to me that the problem is there not in the
kernel.  So I am pushing back and saying get your user space act together
and then this kernel option won't matter.

I am further saying that this selecting how much memory to use is the least
of your problems.

Eric
