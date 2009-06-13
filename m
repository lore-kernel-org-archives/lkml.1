Return-Path: <linux-kernel-owner+w=401wt.eu-S1759710AbZFMUxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710AbZFMUxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbZFMUxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:53:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42492 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZFMUxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:53:32 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
	<20090610190841.GT8633@ZenIV.linux.org.uk>
	<20090610121633.d678fc8b.akpm@linux-foundation.org>
	<4A305A99.70701@redhat.com> <20090611031005.GU8633@ZenIV.linux.org.uk>
	<4A309557.8040508@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Jun 2009 13:53:30 -0700
In-Reply-To: <4A309557.8040508@redhat.com> (Amerigo Wang's message of "Thu\, 11 Jun 2009 13\:25\:43 +0800")
Message-ID: <m1ski3n9dh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: 2.6.31 -mm merge plans
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Al Viro wrote:
>> On Thu, Jun 11, 2009 at 09:15:05AM +0800, Amerigo Wang wrote:
>>   
>>> Hi, Al.
>>>
>>> Just as what I said in the description of that patch, one only has  extern
>>> functions that are _only_ used in another as function pointers.
>>>     
>>
>> Er...  So what?  Amount of functions made static is not, per se, a
>> useful metrics of anything.
>>   
> Not only about static, but also because they are used via function pointers.
>
> Logically, it is better for these functions used via pointers to be kept in
> the same file with the struct which holds these function pointers.

I am going to agree with Al here.  array.c has a well defined function
and purpose.  base.c is on it's way to becoming a dumping ground.  The
only reason the functions in array.c are used directly in base.c is
that we don't have a way to dynamically register struct pid_entry's.

Given the number of ifdefs in base.c it looks like it could really benefit
from splitting up.   I made it about half way there last time I was working
on proc.

Eric
