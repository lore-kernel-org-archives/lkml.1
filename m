Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbZCOWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbZCOWxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbZCOWwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:52:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:36236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbZCOWwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:52:53 -0400
Date: Sun, 15 Mar 2009 15:47:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
Message-ID: <20090315154718.00353625@infradead.org>
In-Reply-To: <49BD6D0E.1010107@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
	<1236931920-6861-11-git-send-email-jeremy@goop.org>
	<49BA3A84.76E4.0078.0@novell.com>
	<49BA7810.6090807@goop.org>
	<49BD4CE1.6040100@zytor.com>
	<49BD6D0E.1010107@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Mar 2009 14:03:10 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> H. Peter Anvin wrote:
> > Jeremy Fitzhardinge wrote:
> >   
> >> Jan Beulich wrote:
> >>     
> >>> As pointed out on an earlier thread, it seems inappropriate to do
> >>> probing like this when there is a cpuid feature flag (osxsave)
> >>> that can be used to
> >>> determine whether XSAVE can be used. And even without that flag,
> >>> simply reading CR4 and checking whether osxsave is set there would
> >>> suffice. This is under the assumption that Xen's to-be-done
> >>> implementation
> >>> of XSAVE support would match that of FXSAVE (Xen turns its
> >>> support on unconditionally and for all [pv] guests).
> >>>       
> >> I didn't want to make too many assumptions about how Xen's XSAVE
> >> support would look.  In particular, I thought it might virtualize
> >> the state of OSXSAVE to give the guest the honour of appearing to
> >> enable it.  A guest kernel may get confused if it starts with
> >> OSXSAVE set, as it may use it to control its own init logic.
> >>     
> >
> > That wouldn't be an issue if you use the *native* CPUID to look for
> > OSXSAVE early on, since such virtualization would only be visible
> > though the PV interface, right?
> >
> > It seems cleaner than probing, to be sure...
> >   
> 
> Well, at the moment the problem is that cpuid (both PV and native)
> show XSAVE, but Xen prevents cr4.OSXSAVE from being set, crashing the 
> kernel.  There's now a patch in Xen to mask XSAVE in CPUID, so that 
> guests don't try to use it; the patch in the kernel is just to
> support non-bleeding-edge versions of Xen.

This is indicative of something that might be a huge bug in Xen:
Xen should never ever pass through CPUID bits it does not know.
If Xen does not honor that, there is a fundamental and eternally
recurring problem.... every time something new gets introduced Xen
likely breaks.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
