Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbXL3WRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbXL3WRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXL3WRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:17:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57590 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbXL3WRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:17:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Date: Sun, 30 Dec 2007 23:37:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200712281353.37976.rjw@sisk.pl> <200712302308.51562.rjw@sisk.pl> <20071230215745.GB31386@elte.hu>
In-Reply-To: <20071230215745.GB31386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712302337.23896.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 of December 2007, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > what's exactly in the hibernation image? Dirty data i suppose
> > 
> > No, everything, including the kernel code, page tables etc. :-)
> > 
> > > - but what about kernel-internal pages. What if we go from SLAB to 
> > > SLUB? What if the size of a structure changes? Etc.
> > 
> > We can go from SLAB to SLUB just fine, it doesn't matter.  The only 
> > thing that matters is we have to jump to the right address at the end 
> > of core_restore_code() (defined in arch/x86/kernel/suspend_asm_64.S).
> 
> ok, just to make sure we are talking about the same thing. Do you mean 
> we can restore an image saved by v2.6.12 into v2.6.24? I.e. a 2.6.24 
> kernel will be able to run a 2.6.12 kernel's hibernation image, with all 
> the kernel internal data from v2.6.12, etc? No way can that work.

Well, not exactly.  The support for different boot and image kernels has
only been merged recently, but we can use the current git to restore
2.6.24-rc6-mm1, for example.

The trick is to pass a little additional information in the image header
that can be used by the boot kernel to locate the entry point to the image
kernel and the image kernel's page tables.

Rafael
