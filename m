Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYGGJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYGGJcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYGGJb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:31:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbYGGJb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:31:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andreas Schwab <schwab@suse.de>
X-Fcc: ~/Mail/linus
Cc: benh@kernel.crashing.org, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
In-Reply-To: Andreas Schwab's message of  Monday, 7 July 2008 09:49:57 +0200 <je8wwet9p6.fsf@sykes.suse.de>
References: <20080703234140.GC9594@localdomain>
	<20080704021929.5E9EF1541F5@magilla.localdomain>
	<1215409693.8970.79.camel@pasglop>
	<20080707061811.19989154246@magilla.localdomain>
	<1215411800.8970.91.camel@pasglop>
	<20080707063522.5FE55154246@magilla.localdomain>
	<je8wwet9p6.fsf@sykes.suse.de>
X-Windows: dissatisfaction guaranteed.
Message-Id: <20080707093151.8798A154246@magilla.localdomain>
Date: Mon,  7 Jul 2008 02:31:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That will make it part of the kernel ABI, since the mapping depends on
> the running kernel, doesn't it?

Well, not the permanent ABI in the sense that AT_* et al are.  This
mapping must agree among all users sharing the same ld.so.cache file.
That is all.  So if you were to change the meaning of a bit that was
used before with a different string, then you could not have the
conflicting ld.so.conf.d files both installed at the same time
(ldconfig will complain and fail).  If you wanted to have two kernels
both installed that disagree on the string for a given bit, then you'd
have to switch the ld.so.conf.d files and re-run ldconfig when you
switch which kernel you're booting.

There are 32 bits free now.  One can anticipate that reassigning a bit
would come up only after these are exhausted.  With prudent use, this
will take a very long time to happen.  Then the oldest CPU type string
might be retired to reuse its bit.  It seems unlikely that there will
be a single installation (root directory) that really needs to have
installed both a kernel optimized for the oldest CPU model known and a
kernel optimized for the newest CPU model known.  If there is, we can
worry about it then.  

At any rate, the point remains that these bit assignments are not part
of any published userland ABI one has to think about in all the ways
that the real ABI implies.  There is nowhere that has to know them or
will ever consider them, except the kernel with the vDSO image built
inside and the ld.so.conf.d file that goes with it.


Thanks,
Roland
