Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbXLDGPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbXLDGPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 01:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbXLDGOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 01:14:52 -0500
Received: from mail.arctic.org ([208.69.40.137]:40548 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751539AbXLDGOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 01:14:51 -0500
Message-ID: <4754F053.8060303@kernel.org>
Date: Mon, 03 Dec 2007 22:14:43 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, jmorris@sergelap.austin.ibm.com,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com>
In-Reply-To: <4754D76B.8080406@ak.jp.nec.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

KaiGai Kohei wrote:
> Serge,
> 
> Please tell me the meanings of the following condition.
> 
>> diff --git a/security/commoncap.c b/security/commoncap.c
>> index 3a95990..cb71bb0 100644
>> --- a/security/commoncap.c
>> +++ b/security/commoncap.c
>> @@ -133,6 +119,12 @@ int cap_capset_check (struct task_struct *target,
>> kernel_cap_t *effective,
>>          /* incapable of using this inheritable set */
>>          return -EPERM;
>>      }
>> +    if (!!cap_issubset(*inheritable,
>> +               cap_combine(target->cap_inheritable,
>> +                       current->cap_bset))) {
>> +        /* no new pI capabilities outside bounding set */
>> +        return -EPERM;
>> +    }
>>  
>>      /* verify restrictions on target's new Permitted set */
>>      if (!cap_issubset (*permitted,
> 
> It seems to me this condition requires the new inheritable capability
> set must have a capability more than bounding set, at least.
> What is the purpose of this checking?

Yes, the !! was a bug. The correct check is a single !.

(Thus, the correct check says no 'new' pI bits can be outside cap_bset.)

Cheers

Andrew

> 
> In the initial state, any process have no inheritable capability set
> and full bounding set. Thus, we cannot do capset() always.
> 
> Thanks,

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHVPBS+bHCR3gb8jsRAnxQAJ0Vna82bl9M11OL/uuEe21nF5+9TACfSzGi
aY0SUvMmLZCIF0KovBTpihE=
=wT9N
-----END PGP SIGNATURE-----
