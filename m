Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbYF3Wba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbYF3Wba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbYF3WbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:31:20 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:64761 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbYF3WbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:31:20 -0400
Date: Mon, 30 Jun 2008 22:31:19 +0000
From: Sean Young <sean@mess.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080630223119.GB58260@atlantis.8hz.com>
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48695871.8000805@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 03:04:33PM -0700, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> >It's a bit odd that the boot loader neglected to set up ds properly, but 
> >changing the testb line to
> >
> >    testb $(1<<6), %cs:BP_loadflags(%esi)
> >
> >should work.  (Or perhaps a %ss: override would be better?)
> >
> >I'm assuming that the GDT setup isn't completely mad and that the 
> >segments have the same base at least.
> >
> 
> This should have been set up by the *boot code* (specifically lines 
> 57-61 of arch/x86/boot/pmjump.S) since he's using a conventional boot 
> loader (syslinux) so something is utterly fuggled up.  Using %cs: here 
> should be safe, though (and *is* more conservative, after all, why 
> otherwise bother reloading these segments at all?), but it still 
> concerns me a great deal if this is broken in this way.  It's definitely 
> better than %ss:.
> 
> In particular, I'm wondering if the Elan CPU has any strange ordering 
> requirements with regards to the protected mode transition that we're 
> not obeying.
> 
> It would be interesting to put in a heavyweight "brutally synchronizing" 
> instruction like WBINVD at various places in arch/x86/boot/pmjump.S and 
> see if it helps.

You are right. With wbinvd before %ds is changed in that file the kernel
boots. 


Sean
