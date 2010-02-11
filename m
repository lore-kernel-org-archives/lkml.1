Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab0BKSWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:22:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:29656 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab0BKSWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KQ9Lt3tEIRLbLTdSDyhlWEIpkUC42zVtyFHCqKwD2mfXnRlVQup6FaL76HrICHDsHC
         ECbG5JP+JJeWMizDkCVXCy5PP0+8H4IJqq010jq7vtntHvo1KMNHBnptSR+cgauLRhMW
         PL2eHI7t6mj1hbt11/6fhXvplKFgFb7foAkkI=
Date: Thu, 11 Feb 2010 19:22:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100211182224.GC4915@nowhere>
References: <4B743149.4000707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B743149.4000707@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 05:33:13PM +0100, Michael Stefaniuc wrote:
> Hello!
> 
> 2.6.33-rc1 broke ptrace for Wine, specifically the setting of the debug
> registers. This is visible in the Wine ntdll exception tests failing on
> 2.6.33-rcX while they work just fine in 2.6.32.
> 
> A regression test resulted in:
> 72f674d203cd230426437cdcf7dd6f681dad8b0d is the first bad commit
> commit 72f674d203cd230426437cdcf7dd6f681dad8b0d
> Author: K.Prasad <prasad@linux.vnet.ibm.com>
> Date:   Mon Jun 1 23:45:48 2009 +0530
> 
>     hw-breakpoints: modify Ptrace routines to access breakpoint registers
> 
>     This patch modifies the ptrace code to use the new wrapper routines
> around
> the
>     debug/breakpoint registers.
> 
>     [ Impact: adapt x86 ptrace to the new breakpoint Api ]
> 
>     Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
>     Signed-off-by: Maneesh Soni <maneesh@linux.vnet.ibm.com>
>     Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> :040000 040000 f72ff4760c3fa1dffcd72494e77bee2c76039505
> b60d5fe2088ff635568e800d5759a0b373b5e439 M      arch
> 
> 
> The first ntdll exception test in test_exceptions()
> http://source.winehq.org/git/wine.git/?a=blob;f=dlls/ntdll/tests/exception.c;h=9149b6961764dec31a0af5cd3b93ab3072703dbb;hb=312e4f6b235a468f8bf764101a5b97cf34dd4143#l594
>   run_exception_test(dreg_handler, NULL, &segfault_code,
> sizeof(segfault_code),
> 0);
> produces (make exception.ok) the output:
>   err:seh:setup_exception_record stack overflow 932 bytes in thread 0009 eip
> 7bc3c97f esp 00240f8c stack 0x240000-0x241000-0x340000
> The stack overflow is detected by the ntdll internal function
> setup_exception_record()
> http://source.winehq.org/git/wine.git/?a=blob;f=dlls/ntdll/signal_i386.c;h=4eccb61954c43d75144575411313d59405decfc3;hb=312e4f6b235a468f8bf764101a5b97cf34dd4143#l1495
> which aborts the thread.
> The problem happens on both i386 (Intel Atom CPU) as well as on x86_64
> (Intel Q9450); the stack overflow bytes differ though but are always the
> same for each box.
> 
> All the ntdll exception tests run just fine with 2.6.32 and older
> kernels. For a summary of the ntdll exception tests please see
> http://test.winehq.org/data/tests/ntdll:exception.html in the Wine
> column.
> 
> I have opened also http://bugzilla.kernel.org/show_bug.cgi?id=15273 for
> this.
> 
> thanks
> bye
>     michael


Thanks a lot for your report. Is there an easy way to reproduce
this?

