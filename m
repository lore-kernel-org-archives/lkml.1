Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYE0TJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYE0TJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYE0TIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:08:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37264 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757762AbYE0TIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:08:52 -0400
Date: Tue, 27 May 2008 14:08:48 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, mingo@elte.hu
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
 memory entries to kernel
Message-Id: <20080527140848.ce57845b.pj@sgi.com>
In-Reply-To: <1211857948.12819.84.camel@caritas-dev.intel.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
	<20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
	<1211857948.12819.84.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Because EFI memory map are converted to E820 memory map in boot loader
> if the converted E820 entry number is below 128 now, I think it is
> better to do all the conversion in boot loader. The limitation lies in
> the size of struct boot_params (zero page), which is 4k. But there is an
> extension to struct boot_params named linked list of struct setup_data
> in a previous patch:
> 
> http://lkml.org/lkml/2008/3/27/26

That previous patch of yours that you reference required modifying
the long standing E820 interface to the kernel, including bumping the
boot_params.hdr.version from 0x0208 to0x0209, and required reserving
additional early boot memory, in order to manage new linked list
data structures to be passed to the kernel and to allocate space for
these structures in early boot.

Why do you think that patch is better?  You say "because entries below
128 are already converted to the E820 map."

But I reply mine is better, because we can already provide, with the
current EFI interfaces, all the entries from the boot loader to the
kernel, so we do not need to provide them twice, a second time via an
E820 map mechanism that must be revised and extended to handle the
additional memory map entries past the first 128 of them.

Why should we do the extra work of passing something in a more difficult
manner, revising a key interface, when we can already pass it with
existing interface?

As Andi Kleen wrote on Feb 20, 2008:
> Just getting it directly from EFI is certainly easier in Linux
> than to do any complicated boot protocol extensions.

Resolving this need to pass more than 128 memory map entries has been
in development now for over six months.  I see related developments in
this area dating back to early October 2007.  I have been quite
explicit since January of 2008 that we (SGI) needed a solution to this
fairly soon.  I am running out of time, and need to have a solution to
this accepted.

If at some point you have other reasons to revision the EFI and E820
interfaces, for example to pass the EDD BIOS Enhanced Disk Drive
Services past what the classic E820 interface handles, that would be
fine my me.

I am not opposed to your patch mentioned above.  It's just that I don't
think it is needed for this particular purpose, of extending the number
of memory map entries past 128.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
