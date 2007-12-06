Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbXLFFjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbXLFFjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXLFFjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:39:18 -0500
Received: from mail.arctic.org ([208.69.40.137]:53489 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751932AbXLFFjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:39:17 -0500
Message-ID: <47578AFC.7040702@kernel.org>
Date: Wed, 05 Dec 2007 21:39:08 -0800
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
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com> <4754F053.8060303@kernel.org> <4755701C.7070407@ak.jp.nec.com> <4756C436.706@kernel.org> <47575AB1.5090501@ak.jp.nec.com>
In-Reply-To: <47575AB1.5090501@ak.jp.nec.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

KaiGai Kohei wrote:
> BTW, could you tell me your intention about pam_cap.c is implemented
> with pam_sm_authenticate() and pam_sm_setcred()?
> I think it can be done with pam_sm_open_session(), and this approach
> enables to reduce the iteration of reading /etc/security/capability.conf.
> 
> How do you think the idea?

Good question! If you want to add session support you can. I'd prefer it
if you retained support for the auth/cred API too: admin choice and all
that. To remove the second read of the file, you can use a PAM data item
to cache the desired capability info after the first read of the file.

I implemented it as a credential module (which has to get the
authentication return code right to make the credential stack execute
correctly) because I think of capabilities as credentials.

That being said, the credentials vs. session thing is not well
delineated by many applications, so it is arguably useful to provide
both interfaces for the admin to make use of on a per application basis.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHV4r8mwytjiwfWMwRAlOsAJ9MQQN0cLhH2lhx9gwvwHsMhQ72ggCfcKWt
/krnNdiAisfcbcXDfssdbLE=
=+0r1
-----END PGP SIGNATURE-----
