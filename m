Return-Path: <linux-kernel-owner+w=401wt.eu-S1945925AbXDEGcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925AbXDEGcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945930AbXDEGcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:32:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945925AbXDEGcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:32:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, "Jan Beulich" <JBeulich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped location with COMPAT_VDSO
In-Reply-To: Jeremy Fitzhardinge's message of  Wednesday, 4 April 2007 21:58:26 -0700 <20070405045843.333498131@goop.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070405063152.9227D180064@magilla.sf.frob.com>
Date: Wed,  4 Apr 2007 23:31:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks nice and clean.  However, it does not relocate the symbol
table(s) values.  I thought that was done in an earlier version of this I
saw, but I might be misremembering.  Though not fatal, this is a regression
from the previous CONFIG_COMPAT_VDSO behavior.  It will show up in things
like __kernel_* name display in backtraces.  If with your other patch
CONFIG_COMPAT_VDSO will become other than a rarely-used compatibility
option, then this should be fixed.  Note that with your second patch this
will also break the symbol values in the randomly-located vma vdso;
non-ancient glibc doesn't care if the vdso isn't mapped where its phdrs
say, but everything does still care that the symbol tables in an ELF file
use addresses matching the phdrs in the same file.


Thanks,
Roland
