Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYCIQ3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYCIQ3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 12:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYCIQ2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 12:28:55 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:49581 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYCIQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 12:28:54 -0400
Message-ID: <47D4103F.6070409@kernel.org>
Date: Sun, 09 Mar 2008 09:28:47 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: prctl(0x8) -> EINVAL [Was: 2.6.25-rc3-mm1]
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <47CE7B1F.3000208@gmail.com> <20080305140624.GA9128@sergelap.austin.ibm.com>
In-Reply-To: <20080305140624.GA9128@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

Serge E. Hallyn wrote:
|
| This patch address the !CONFIG_SECURITY case, but not the case of
| using the dummy LSM.  The default these days is to have capabilities
| compiled in no matter what, but it is still possible to have
| CONFIG_SECURITY=y and CONFIG_SECURITY_CAPABILITIES=n, in which
| case prctl(0x8) will return -EINVAL.  Do we want dummy to call
| cap_prctl() as well, or are we ok with userspace getting -EINVAL
| given that there are in fact no capabilities at that point and
| the userspace code is clearly expecting them?
|
| thanks,
| -serge
|
|>From 4a66f19580489a3ac84f0a145e4585c09e65c88e Mon Sep 17 00:00:00 2001
| From: Serge E. Hallyn <serue@us.ibm.com>
| Date: Wed, 5 Mar 2008 06:02:32 -0800
| Subject: [PATCH 1/1] capabilities: use cap_task_prctl when
!CONFIG_SECURITY
|
| capabilities-implement-per-process-securebits.patch introduced
| cap_task_prctl() and moved the handling of capability-related
| prctl into it.  So when !CONFIG_SECURITY, the default
| security_task_prctl() needs to call cap_task_prctl() the way
| other default hooks call capability helpers when they exist.
|
| This fixes a slew of userspace breakages when
| CONFIG_SECURITY=n.
|
| Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
| ---
|  include/linux/security.h |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
|
| diff --git a/include/linux/security.h b/include/linux/security.h
| index 83763b0..861d6da 100644
| --- a/include/linux/security.h
| +++ b/include/linux/security.h
| @@ -2228,7 +2228,7 @@ static inline int security_task_prctl (int
option, unsigned long arg2,
|  				       unsigned long arg4,
|  				       unsigned long arg5, long *rc_p)
|  {
| -	return 0;
| +	return cap_task_prctl(option, arg2, arg3, arg3, arg5, rc_p);
|  }
|
|  static inline void security_task_reparent_to_init (struct task_struct *p)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH1BA/mwytjiwfWMwRAkQ3AJ4h7rKORHnRvoQrPh/l1psZEwsRJACePk1T
AooB76FrfRd63O2kOpPvqNU=
=rxzU
-----END PGP SIGNATURE-----
