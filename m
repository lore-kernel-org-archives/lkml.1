Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbXLLWbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbXLLWbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXLLWas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:30:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53809 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbXLLWar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:30:47 -0500
Date: Wed, 12 Dec 2007 14:21:46 -0800
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
Message-ID: <20071212222146.GC16474@kroah.com>
References: <1197449991.14443.88.camel@caritas-dev.intel.com> <20071212174613.GC16049@kroah.com> <47602044.9010104@zytor.com> <20071212185935.GA5941@kroah.com> <47603109.6080909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47603109.6080909@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 11:05:45AM -0800, H. Peter Anvin wrote:
> Greg KH wrote:
>>> This is a binary structure defined by protocol;
>> What protocol?  Is this a "standard" documented somewhere?
>
> Yes, see Documentation/i386/* (although some of it is documented by 
> reference to include/asm-x86/boot_params.h).

Ah, so the structure has changed over the years, making this not so much
a "firmware" field as originally thought :)

>>> in that way it's not significantly different from something passed
>>> from the firmware (in fact, it might very well *be* passed from the
>>> firmware.)  We have in the past found platform bugs by looking at the
>>> contents of the whole structure, e.g.  to find that part of it has
>>> been inappropriately clobbered.
>> For debugging things, then just export it through debugfs.
>
> Fair enough, however...
>
>>> It is also in the form needed by e.g. kexec to operate.
>> Does kexec need this today to work properly?  Or is this something new?
>
> I believe kexec currently tries to reconstitute it from what data is 
> available to it.  This is incomplete, though, and has been flagged as a 
> problem for kexec.

Can't kexec get this from within the kernel itself when it is running?
It doesn't need to get this from userspace, does it?

>> What userspace program is going to know the exact data format of this
>> blob, and where is it going to know that format from?  The kernel header
>> files in sanitized form?  Or something else?
>
> It can pick it up from <asm/boot_params.h> (which is now userspace-safe); 
> or it can decode it itself.  Programs like kexec can pass through most of 
> the data without examining it, this is the main reason for having it as a 
> blob.

I just don't want kernel structures exported in binary fashions in
sysfs.  If there are specific portions that kexec currently can't figure
out, why not just export those fields?

And, by exporting the different fields (yeah, lots of files, no big
deal), you can handle the change in the structure over time much easier
than trying to "know" the layout of the binary blob.

thanks,

greg k-h
