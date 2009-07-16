Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbZGPUqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbZGPUqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933325AbZGPUqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:46:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32904 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933324AbZGPUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:46:35 -0400
Date: Thu, 16 Jul 2009 16:46:07 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
In-Reply-To: <20090716203432.GB6096@merkur.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu> <20090716203432.GB6096@merkur.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Sam Ravnborg wrote:

> On Sun, Jul 12, 2009 at 06:23:33PM -0400, Tim Abbott wrote:
> > I'd like acks from Sam and David on this one.  Also CCing Paul, since
> > he has a patch from me which will need to be updated to use
> > BSS_SECTION(0, PAGE_SIZE, 4) once this gets merged.
> 
> Path looks good - this is howit should have looked in the first place.
> I recall that the alignmnet of 4 came from what is default for ld at least
> for i386 but it really is dependent on the routine that clears the bss
> section so we better make it configurable. Some archs may prefer to clear
> bss in 8 byte chunks...

Right, e.g. avr32 uses 8 for this.

> Could you please resend including the necessary fix for mn10300 so we do not
> break bisecting.

I don't understand what you're asking here.  The original patch I sent 
does include the necessary fix for mn10300 in the first hunk (reproduced 
below).  I intentionally changed the mn10300 use at the same time as 
changing the macros in order to avoid breaking bisecting.

I'd be happy to resend if it'd be helpful.

--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -107,7 +107,7 @@ SECTIONS
   __init_end = .;
   /* freed after init ends here */
 
-  BSS(4)
+  BSS_SECTION(0, PAGE_SIZE, 4)
 
   _end = . ;
 


	-Tim Abbott


