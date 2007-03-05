Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXCEV6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXCEV6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXCEV6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:58:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXCEV6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:58:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <ak@suse.de>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
In-Reply-To: Andi Kleen's message of  Monday, 5 March 2007 15:27:15 +0100 <20070305142715.GC22829@bingen.suse.de>
X-Shopping-List: (1) Anachronistic crosswords
   (2) Nuclear minions
   (3) Igneous finger flossbags
Message-Id: <20070305215838.051CD1800E5@magilla.sf.frob.com>
Date: Mon,  5 Mar 2007 13:58:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does the old userland compatibility you're concerned about really need the
vdso to be at 0xfffffe000 in particular, or just need it to be at a fixed
address that matches the phdrs inside the image?  My recollection of the old
glibc's limitation was that it expected the image's phdrs to match its load
address.  The xen kernels used to change this to 0xffffd000 or something,
and AFAIK that was fine.  If that's all that's needed, it is not so hard to
adjust the vDSO contents at boot time (phdrs, shdrs, and symbols; no code
contents use the absolute address).  Under CONFIG_COMPAT_VDSO, it can see
where the paravirt moved the fixmap to, and apply adjustments.

That said, I don't think this is worth all that much effort since
CONFIG_COMPAT_VDSO is not really desireable for most people.  I think
disabling the vdso under CONFIG_COMPAT_VDSO+CONFIG_PARAVIRT is survivable
(just don't set CONFIG_COMPAT_VDSO for a system you want to be optimal).


Thanks,
Roland
