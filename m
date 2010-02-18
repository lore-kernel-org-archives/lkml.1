Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab0BRQfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:35:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52745 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab0BRQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:35:42 -0500
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, mort@sgi.com, linux-arch@vger.kernel.org
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
	<1266014143-29444-9-git-send-email-jason.wessel@windriver.com>
	<m1zl37xhmm.fsf@fess.ebiederm.org> <4B7D5704.6060504@windriver.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Feb 2010 08:35:32 -0800
In-Reply-To: <4B7D5704.6060504@windriver.com> (Jason Wessel's message of "Thu\, 18 Feb 2010 09\:04\:36 -0600")
Message-ID: <m1fx4ywlgr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jason Wessel <jason.wessel@windriver.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 08/28] kdb: core for kgdb back end (2 of 2)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel <jason.wessel@windriver.com> writes:

> Eric W. Biederman wrote:
>> Jason Wessel <jason.wessel@windriver.com> writes:
>>
>>   
>>> This patch contains the hooks and instrumentation into kernel which
>>> live outside the kernel/debug directory, which the kdb core
>>> will call to run commands like lsmod, dmesg, bt etc...
>>>     
>>
>> You know this dropping the locks from vmalloc_info and swap_info
>> is down right ugly, and I don't believe it is safe.  That code
>> was not designed to run while the write_lock is held.
>>   
>
> Perhaps we can find some middle ground.  I don't mind simply not
> allowing the information to be queried from kdb if the locks are not
> available. 
>
> Which is less ugly you, making the swap_lock global or adding a function
> to query it?

My recommendation would be to simply drop the swap_info and meminfo
information for now, and have kdb do what is good at.

Skimming through the history of the discussion it appears Christoph
Hellwig asked you to do something about these bits on the first
review.

>From a maintenance point of view anything where you have to know which
locks a function will take is fragile.  It is entirely too easy to create
a change that is fine in it's normal context but breaks kdb.

Alt-sysrq already allows capturing that kind of information, without any
thorny maintenance issues.  By contrast kdb appears to be a much larger
and inferior tool.

Eric
