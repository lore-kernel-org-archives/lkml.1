Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbXGKUvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbXGKUvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761193AbXGKUv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:51:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760370AbXGKUv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:51:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: Linus Torvalds's message of  Wednesday, 11 July 2007 12:16:33 -0700 <alpine.LFD.0.999.0707111215170.20061@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070711205120.396CD4D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 13:51:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[I'd meant to send that from roland@redhat.com, so please correct any
followups.]

> Umm. You seem to make it readable by everybody. That's a mistake, I think. 
> I don't know if there is anything security-conscious there, but just on 
> general principles, I don't think we really would want normal users 
> reading kernel configuration info, no?

What I expect to find in notes I'd call kernel version and identification
info, not configuration info.  I don't think it's likely to be any more
revealing than "uname -v".  The main use I have in mind is to check
exactly which kernel binary you have, though indeed that is only of any
use to someone who can do something with kernel addresses and such.  It
is probably a lot less revealing on its own than /proc/config.gz or
/proc/kallsyms, which are world-readable.

It hadn't really occurred to me that the kernel binary would be
deliberately hidden from the user.  If you are doing that, indeed
/sys/kernel/noes is of no use to the user and you probably want to hide
it too.  Still, I think it is more useful that the default be to let an
unprivileged user see this as they can see /proc/kallsyms.  Both are
useful for the same sorts of things, i.e. making sense of kernel
addresses from oops logs or whatnot.  /sys/kernel/notes will be a part of
"eu-addr2line -k 0x12345" being reliable and automatic, for example (it
already works now with kernel-debuginfo installed, but this will help it
reliably figure out if you botched the install or something).


Thanks,
Roland
