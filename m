Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYJVMwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYJVMwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYJVMvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:51:51 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:51348 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYJVMvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:51:50 -0400
Message-ID: <48FF21BF.9090509@kernel.org>
Date: Wed, 22 Oct 2008 05:51:11 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com, viro@zeniv.linux.org.uk, sgrubb@redhat.com
Subject: Re: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
 inheritable capabilities
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com> <20081020222612.3895.6710.stgit@paris.rdu.redhat.com> <48FD6E49.6060104@kernel.org> <20081021191625.GA4657@us.ibm.com>
In-Reply-To: <20081021191625.GA4657@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

[s/viro@...ok/viro@...uk/]

Serge E. Hallyn wrote:
>> Logging execve()s where there is only an increase in capabilities seems
>> wrong to me. To me it seems equally important to log any event where an
>> execve() yields pP != 0.
> 
> True.
> 
> ... except if (!issecure(SECURE_NOROOT) && uid==0) I guess?
> 
> And then it also might be interesting in the case where
> (!issecure(SECURE_NOROOT) && uid==0) and pP is not full.

I guess so, although this seems like a case of being interested in a
(unusual) non-privileged execve().

>>>  	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
>>>  
>>> +	audit_log_bprm_fcaps(bprm, &vcaps);
>>> +
>> When rc != 0, the execve() will fail. Is it appropriate to log in this case?
> 
> It might fail because fP contains bits not in pP', right?  That's
> probably interesting to auditors.

In which case, how is the fact it didn't execute captured in the audit log?

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI/yG9+bHCR3gb8jsRAii1AKCDluqUSVyAKP67/9bhEgqdlx3xdACg0dn4
81bi/3eMaP1FqfdVK2u/BpM=
=QBli
-----END PGP SIGNATURE-----
