Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbXLLWpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbXLLWpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXLLWpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:45:42 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57126 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXLLWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:45:41 -0500
Date: Wed, 12 Dec 2007 14:43:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Huang, Ying" <ying.huang@intel.com>,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
Message-Id: <20071212144351.3fd0c6ec.randy.dunlap@oracle.com>
In-Reply-To: <20071212222146.GC16474@kroah.com>
References: <1197449991.14443.88.camel@caritas-dev.intel.com>
	<20071212174613.GC16049@kroah.com>
	<47602044.9010104@zytor.com>
	<20071212185935.GA5941@kroah.com>
	<47603109.6080909@zytor.com>
	<20071212222146.GC16474@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 14:21:46 -0800 Greg KH wrote:

> On Wed, Dec 12, 2007 at 11:05:45AM -0800, H. Peter Anvin wrote:
> > Greg KH wrote:
> >>> This is a binary structure defined by protocol;
> >> What protocol?  Is this a "standard" documented somewhere?
> >
> > Yes, see Documentation/i386/* (although some of it is documented by 
> > reference to include/asm-x86/boot_params.h).
> 
> Ah, so the structure has changed over the years, making this not so much
> a "firmware" field as originally thought :)
> 
> >>> in that way it's not significantly different from something passed
> >>> from the firmware (in fact, it might very well *be* passed from the
> >>> firmware.)  We have in the past found platform bugs by looking at the
> >>> contents of the whole structure, e.g.  to find that part of it has
> >>> been inappropriately clobbered.
> >> For debugging things, then just export it through debugfs.
> >
> > Fair enough, however...
> >
> >>> It is also in the form needed by e.g. kexec to operate.
> >> Does kexec need this today to work properly?  Or is this something new?
> >
> > I believe kexec currently tries to reconstitute it from what data is 
> > available to it.  This is incomplete, though, and has been flagged as a 
> > problem for kexec.
> 
> Can't kexec get this from within the kernel itself when it is running?
> It doesn't need to get this from userspace, does it?

I don't know if this patch is trying to solve this (->) problem, but there
is a desire for drivers to have a decent way to tell if the kernel that
is executing is a kexec/crash kernel or not.  If it is a kexec/crash
kernel, then (some) drivers may not allocate as many buffers as they
normally do, since the kernel would likely be configured to use
less memory.  The solution doesn't have to involve sysfs .. or it could.


> >> What userspace program is going to know the exact data format of this
> >> blob, and where is it going to know that format from?  The kernel header
> >> files in sanitized form?  Or something else?
> >
> > It can pick it up from <asm/boot_params.h> (which is now userspace-safe); 
> > or it can decode it itself.  Programs like kexec can pass through most of 
> > the data without examining it, this is the main reason for having it as a 
> > blob.
> 
> I just don't want kernel structures exported in binary fashions in
> sysfs.  If there are specific portions that kexec currently can't figure
> out, why not just export those fields?
> 
> And, by exporting the different fields (yeah, lots of files, no big
> deal), you can handle the change in the structure over time much easier
> than trying to "know" the layout of the binary blob.

---
~Randy
