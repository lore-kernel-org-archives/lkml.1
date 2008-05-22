Return-Path: <linux-kernel-owner+w=401wt.eu-S935404AbYEVNTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404AbYEVNTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761854AbYEVNTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:19:35 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:50031 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760573AbYEVNTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:19:34 -0400
Message-ID: <483572CC.9060705@kernel.org>
Date: Thu, 22 May 2008 06:19:08 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: protect legacy apps from insufficient privilege
References: <483444C1.6050308@kernel.org> <20080521224137.8d5c0089.akpm@linux-foundation.org>
In-Reply-To: <20080521224137.8d5c0089.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
| With a judiciously placed `continue' we can do this:
|
| 	CAP_FOR_EACH_U32(i) {
| 		__u32 value_cpu;
|
| 		if (i >= tocopy) {
| 			/*
| 			 * Legacy capability sets have no upper bits
| 			 */
| 			bprm->cap_post_exec_permitted.cap[i] = 0;
| 			continue;
| 		}
| 		/*
| 		 * pP' = (X & fP) | (pI & fI)
| 		 */
| 		value_cpu = le32_to_cpu(caps->data[i].permitted);
| 		bprm->cap_post_exec_permitted.cap[i] =
| 			(current->cap_bset.cap[i] & value_cpu) |
| 			(current->cap_inheritable.cap[i] &
| 				le32_to_cpu(caps->data[i].inheritable));
| 		if (value_cpu & ~bprm->cap_post_exec_permitted.cap[i]) {
| 			/*
| 			 * insufficient to execute correctly
| 			 */
| 			ret = -EPERM;
| 		}
| 	}
|
| OK?

Yes.

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFINXLL+bHCR3gb8jsRAiGUAJ49d61n7+uhc3M5vJjT5398w9tRGgCgwLRe
vXHOIIJAoHvlGNACagKSPes=
=oPN0
-----END PGP SIGNATURE-----
