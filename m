Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZCZClW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZCZClW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCZClN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:41:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44580 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZCZClM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:41:12 -0400
To: Alex Chiang <achiang@hp.com>
Cc: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
References: <20090325035707.15921.42150.stgit@bob.kio>
	<m13ad2xi46.fsf@fess.ebiederm.org>
	<20090325225414.GA11447@ldl.fc.hp.com>
	<m17i2dunao.fsf@fess.ebiederm.org>
	<20090326012636.GC11447@ldl.fc.hp.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 25 Mar 2009 19:41:00 -0700
In-Reply-To: <20090326012636.GC11447@ldl.fc.hp.com> (Alex Chiang's message of "Wed\, 25 Mar 2009 19\:26\:36 -0600")
Message-ID: <m1iqlxt39f.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: achiang@hp.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kay.sievers@vrfy.org, stern@rowland.harvard.edu, cornelia.huck@de.ibm.com, greg@kroah.com, htejun@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Alex Chiang <achiang@hp.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  1.0 XMSolicitRefs_1 XMSolicitRefs_1
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang <achiang@hp.com> writes:

>> Sounds like it.    I'm not trying to shoot this down, rather
>> I'm trying to figure out how to solve this cleanly, as I am slowly
>> trying to sort out the pci hotplug and unplug issues.
>
> Please do keep me informed on any progress you make or thoughts
> you have here.
>
>> I'm not certain how general we can be. pci layer, device layer or kobject
>> layer, but I think it makes sense to have a dedicated work queue to use
>> when devices are removed.  As every hotplug driver currently has to
>> invent one.  The fake hotplug code is very normal in this respect.
>> 
>> If we can get the work queue creation and the calling of remove put
>> into the generic pci layer, we should be able to simply all of the
>> hotplug controller drivers.
>
> Hm, that is a good idea.
>
> Simplifying all the various hotplug drivers is on my TODO list,
> but it's a long and tricky process. I agree though, there is no
> reason why they should all be as complicated as they are.
>
>> I'm not seeing a patch from you where you are using a separate
>> workqueue.  Am I missing something?  
>
> 	http://lkml.org/lkml/2009/3/25/489
>
> But I suspect that is not the workqueue you are looking for. ;)

Not quite.

>> But if we can place that workqueue in say the pci layer I think
>> it would be just a little re factoring and not a lot more code.
>
> The PCI layer doesn't need a workqueue to remove devices, not on
> its own behalf.
>
> You are talking about providing something for the benefit of all
> the hotplug drivers, right?

Yes.  The common case is that we discover a card needs to be or
has been removed from an interrupt handler.

Eric
