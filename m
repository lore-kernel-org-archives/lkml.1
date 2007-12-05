Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbXLEPbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbXLEPbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXLEPbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:31:14 -0500
Received: from mail.arctic.org ([208.69.40.137]:35953 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490AbXLEPbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:31:11 -0500
Message-ID: <4756C436.706@kernel.org>
Date: Wed, 05 Dec 2007 07:31:02 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com> <4754F053.8060303@kernel.org> <4755701C.7070407@ak.jp.nec.com>
In-Reply-To: <4755701C.7070407@ak.jp.nec.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

KaiGai Kohei wrote:
> Andrew Morgan wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> KaiGai Kohei wrote:
>>>> +    if (!!cap_issubset(*inheritable,
>>>> +               cap_combine(target->cap_inheritable,
>>>> +                       current->cap_bset))) {
>>>> +        /* no new pI capabilities outside bounding set */
>>>> +        return -EPERM;
>>>> +    }
>>>>  

>> Yes, the !! was a bug. The correct check is a single !.
> 
> I was in trouble with getting -EPERM at pam_cap.so :-)
> 
>> (Thus, the correct check says no 'new' pI bits can be outside cap_bset.)
> 
> If this condition intends to dominate 'new' pI bits by 'old' pI bits masked
> with bounding set, we should not apply cap_combine() here.
> I think applying cap_intersect() is correct for the purpose.

The check is not meant to limit existing pI bits.

The check is meant to limit what new bits can be 'added' to pI (in the
case that pE & CAP_SETPCAP is true).

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHVsQ2mwytjiwfWMwRAs9RAKCUyjsjONVhRXooG5I2b+1zU/HLGwCfQIyh
tjdDI9QxJ1DWLCm2Ee29qYA=
=Gwwt
-----END PGP SIGNATURE-----
