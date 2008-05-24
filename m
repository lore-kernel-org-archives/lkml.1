Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYEXB2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYEXB2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYEXB22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:28:28 -0400
Received: from sous-sol.org ([216.99.217.87]:40541 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbYEXB21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:28:27 -0400
Date: Fri, 23 May 2008 18:09:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: capget() overflows buffers.
Message-ID: <20080524010923.GT30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org> <20080523182602.GO30402@sequoia.sous-sol.org> <48375B10.10003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48375B10.10003@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew G. Morgan (morgan@kernel.org) wrote:
> Chris Wright wrote:
> | I'm sure you're painfully aware, but this will need some change
> | to libcap as well (to let it handle 64bit caps again).
>
> Not really.
>
> libcap2 (the one with 64-bit capability support) continues to work fine
> (it ships with its own copy of a compatible linux/capability.h, and when
> I update that, I'll make the corresponding change) but the effect should
> be transparent to its users:

Doh, I missed the leading portion of the pathname (cscope -p3 didn't
show anything more than include/sys/capability.h), thanks.

> | That's what I meant earlier by "And use another mechanism to
> | signal the availability of 64bit caps."
>
> There is and has always been a method:
>
> ~   head.version = 0;
> ~   getcap(&head, NULL);
> ~   switch (head.version) {
> ~   case _LINUX_...:
> ~      ...
> ~      break;
> ~   case _,,,,:
> ~      etc...
> ~      break;
> ~   default:
> ~      abort("no idea what to do");
> ~   }

Hmm, it would be kind of nice to have a formalized way get the size,
perhaps it would help with KaiGai's request for caps printed out.
Something that tells us either the number of u32s, or the max bit
supported?

> | All looks good.  I think we need to issue some warnings, because
> | at least Fedora 9 and openSUSE 11 are/will be 2.6.25 based.
>
> Do any of the above answers help? (FWIW I attached the patch to the
> redhat bug.)

Yes, thanks.  But I still think we need to print a warning (unfortunately
we can't distinguish libcap from non-libcap app), because apps that
aren't using libcap should really be updated (either pull new update
from vendor or recompiled by end user).

thanks,
-chris
