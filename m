Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbXF1Q1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbXF1Q1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXF1Q1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:27:42 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:54232 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbXF1Q1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:27:41 -0400
Message-ID: <4683E17A.3060706@kernel.org>
Date: Thu, 28 Jun 2007 09:27:38 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: get_file_caps cleanups
References: <20070628002041.GA10429@sergelap.austin.ibm.com> <468350D1.9010902@kernel.org> <20070628134702.GB29641@sergelap.austin.ibm.com>
In-Reply-To: <20070628134702.GB29641@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
>>>>  		kfree(dcaps);
> Move this two lines down (rc defaults to 0 in goto above):
> from here-->
>>>> +clear_caps:
>>>> +	if (rc) {
> to here-->
> 
>> Hmm?  But if we succeeded we still want to free dcaps if we
>> kmalloc()'d it.

I wasn't clear enough... Let me try again with different words.

If you look at your patch, you will see that the only use of the label
'clear_caps:' is as a jump target from a location in which rc=0. As
such, you will *not* clear the bprm->cap_* sets... This is the reverse
of what you intended to do.

You need to put the jump target 'inside' the 'if (rc) { <-here ... }'.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGg+F6+bHCR3gb8jsRAm2AAJ9v0fz/S/+HvGWOhU6UBPbB4iY+MACggZqA
+yCrxg2UVKdDKOh6kPfh0QI=
=Qksf
-----END PGP SIGNATURE-----
