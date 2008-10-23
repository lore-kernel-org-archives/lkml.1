Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYJWEPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYJWEPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYJWEOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:14:41 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45817 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYJWEOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:14:40 -0400
Message-ID: <48FFFA07.3060707@kernel.org>
Date: Wed, 22 Oct 2008 21:13:59 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com, viro@zeniv.linux.org.uk, sgrubb@redhat.com
Subject: Re: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
 inheritable capabilities
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com> <20081020222612.3895.6710.stgit@paris.rdu.redhat.com> <48FD6E49.6060104@kernel.org> <20081021191625.GA4657@us.ibm.com> <48FF21BF.9090509@kernel.org> <20081022141430.GB21612@us.ibm.com>
In-Reply-To: <20081022141430.GB21612@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
>>> ... except if (!issecure(SECURE_NOROOT) && uid==0) I guess?
>>>
>>> And then it also might be interesting in the case where
>>> (!issecure(SECURE_NOROOT) && uid==0) and pP is not full.
>> I guess so, although this seems like a case of being interested in a
>> (unusual) non-privileged execve().
> 
> I'm not sure what you mean - but this can only happen if bits are taken
> out of the capability bounding set, right?

Yes, it can happen as you say.

This is a case of an unprivileged uid==0 execution. Since we don't
appear to want to audit other non-privileged execve()s, its not clear to
me that this one deserves attention.

>>>>>  	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
>>>>>  
>>>>> +	audit_log_bprm_fcaps(bprm, &vcaps);
>>>>> +
>>>> When rc != 0, the execve() will fail. Is it appropriate to log in this case?
>>> It might fail because fP contains bits not in pP', right?  That's
>>> probably interesting to auditors.
>> In which case, how is the fact it didn't execute captured in the audit log?
> 
> I assume as a FAIL?  (Not sure of the exact wording in the logs)

OK. As long as its clearly identified as a failure and the logs are not
misleading - making it look like the execve() succeeded with privilege -
then I'm not as concerned.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI//oF+bHCR3gb8jsRAjZxAKCoSXL7CwTfQJt7Wn55nT8MwHbiEgCcD+Qm
VVHHZ9QiInaVb2faUt9Q77E=
=gJU0
-----END PGP SIGNATURE-----
