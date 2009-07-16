Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbZGPUef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbZGPUef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933293AbZGPUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:34:34 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:32823 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933248AbZGPUed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:34:33 -0400
Date: Thu, 16 Jul 2009 22:34:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
Message-ID: <20090716203432.GB6096@merkur.ravnborg.org>
Mail-Followup-To: Tim Abbott <tabbott@ksplice.com>,
	linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Anders Kaseorg <andersk@ksplice.com>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 06:23:33PM -0400, Tim Abbott wrote:
> The BSS section macros in vmlinux.lds.h currently place the .sbss
> input section outside the bounds of [__bss_start, __bss_end].  On all
> architectures except for microblaze that handle both .sbss and
> __bss_start/__bss_end, this is wrong: the .sbss input section is
> within the range [__bss_start, __bss_end].  Relatedly, the example
> code at the top of the file actually has __bss_start/__bss_end defined
> twice; I believe the right fix here is to define them in the
> BSS_SECTION macro but not in the BSS macro.
> 
> Another problem with the current macros is that several
> architectures have an ALIGN(4) or some other small number just before
> __bss_stop in their linker scripts.  The BSS_SECTION macro currently
> hardcodes this to 4; while it should really be an argument.  It also
> ignores its sbss_align argument; fix that.
> 
> mn10300 is the only user at present of any of the macros touched by
> this patch.  It looks like mn10300 actually was incorrectly converted
> to use the new BSS() macro (the alignment of 4 prior to conversion was
> a __bss_stop alignment, but the argument to the BSS macro is a start
> alignment).  So fix this as well.
> 
> I'd like acks from Sam and David on this one.  Also CCing Paul, since
> he has a patch from me which will need to be updated to use
> BSS_SECTION(0, PAGE_SIZE, 4) once this gets merged.

Path looks good - this is howit should have looked in the first place.
I recall that the alignmnet of 4 came from what is default for ld at least
for i386 but it really is dependent on the routine that clears the bss
section so we better make it configurable. Some archs may prefer to clear
bss in 8 byte chunks...

Could you please resend including the necessary fix for mn10300 so we do not
break bisecting.

thanks,
	Sam
