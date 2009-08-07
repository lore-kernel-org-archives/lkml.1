Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZHGWGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZHGWGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZHGWGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:06:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49877 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZHGWGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:06:21 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Amerigo Wang <amwang@redhat.com>, Neil Horman <nhorman@redhat.com>,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Bernhard Walle <bernhard.walle@gmx.de>,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <4A7A3A78.7080200@redhat.com> <m1y6pxr737.fsf@fess.ebiederm.org>
	<4A7A506B.2060008@redhat.com> <m1ljlxsiox.fsf@fess.ebiederm.org>
	<4A7A70E5.2010204@redhat.com> <m1bpmtqxjh.fsf@fess.ebiederm.org>
	<4A7A7A0F.6070906@redhat.com> <m1iqh1nxv3.fsf@fess.ebiederm.org>
	<4A7A9E54.60705@redhat.com> <m1iqgze740.fsf@fess.ebiederm.org>
	<20090807210306.GA25609@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 07 Aug 2009 15:06:10 -0700
In-Reply-To: <20090807210306.GA25609@basil.fritz.box> (Andi Kleen's message of "Fri\, 7 Aug 2009 23\:03\:06 +0200")
Message-ID: <m1prb7nust.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: andi@firstfloor.org, kexec@lists.infradead.org, bernhard.walle@gmx.de, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, nhorman@redhat.com, amwang@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
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
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> As an initial approximation I would use a 32nd of low memory.
>
> That means a 1TB machine will have a 32GB crash kernel.
>
> Surely that's excessive?!?
>
> It would be repeating all the same mistakes people made with hash tables
> several years ago.
>
>> 
>> That can be written to (with enough privileges when no crash kernel is
>> loaded) reduce the amount of memory reserved by the crash kernel.
>> 
>> Bernhard does that sound useful to you?
>> 
>> Amerigo does that seem reasonable?
>
> It doesn't sound reasonable to Andi.
>
> Why do you even want to grow the crash kernel that much? Is there
> any real problem with a 64-128MB crash kernel?

Because it is absolutely ridiculous in size and user space will have
to take up the work of trimming back down to something reasonable in
the init script.

At a practical level crash dump userlands do things like fsck
filesystems before they mount them.  For truly large machines there
was a desire to parallelize core dump writing to different disks.  I
don't know if that has been implemented yet, but in that case you
certainly more ram for buffers tends to be useful.

I think if we are going to go beyond having a magic boot command
line (that we have today) that parametrizes the amount of memory
to reserve based on how much memory we have in the system.  We need
to put user space in control.  We can only put user space in control
if we initially reserve too much and let it release the memory it
won't use.

That would allow removing magic from installers and leaving it to 
installed packages.  Which seems a lot more maintainable. 

Eric
