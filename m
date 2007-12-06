Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbXLFCPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbXLFCPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXLFCOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:14:07 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36925 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbXLFCOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:14:03 -0500
Message-ID: <47575AB1.5090501@ak.jp.nec.com>
Date: Thu, 06 Dec 2007 11:13:05 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com> <4754F053.8060303@kernel.org> <4755701C.7070407@ak.jp.nec.com> <4756C436.706@kernel.org>
In-Reply-To: <4756C436.706@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai Kohei wrote:
>> Andrew Morgan wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> KaiGai Kohei wrote:
>>>>> +    if (!!cap_issubset(*inheritable,
>>>>> +               cap_combine(target->cap_inheritable,
>>>>> +                       current->cap_bset))) {
>>>>> +        /* no new pI capabilities outside bounding set */
>>>>> +        return -EPERM;
>>>>> +    }
>>>>>  
> 
>>> Yes, the !! was a bug. The correct check is a single !.
>> I was in trouble with getting -EPERM at pam_cap.so :-)
>>
>>> (Thus, the correct check says no 'new' pI bits can be outside cap_bset.)
>> If this condition intends to dominate 'new' pI bits by 'old' pI bits masked
>> with bounding set, we should not apply cap_combine() here.
>> I think applying cap_intersect() is correct for the purpose.
> 
> The check is not meant to limit existing pI bits.
> 
> The check is meant to limit what new bits can be 'added' to pI (in the
> case that pE & CAP_SETPCAP is true).

Thanks, I got understood as I wrote in the previous reply.

BTW, could you tell me your intention about pam_cap.c is implemented
with pam_sm_authenticate() and pam_sm_setcred()?
I think it can be done with pam_sm_open_session(), and this approach
enables to reduce the iteration of reading /etc/security/capability.conf.

How do you think the idea?
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
