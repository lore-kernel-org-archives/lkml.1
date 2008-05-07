Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbYEGTWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbYEGTWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbYEGTVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:21:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:24071 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565AbYEGTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lIVnsxL80QfjuSDlToc+/0n/a9mdZZNtCuNEQpThLalEA1+weCu21ixHxPwKQhRu17U9uFGykqoiWnJr4SPaLwiv8tJAU9zbfrbYvWYVw/jiXo4su1uK2BQVSLv4Te//jomsGzMjft8T4WPry0oipeeXBmBTwV/Mf0ii9986Aqk=
Message-ID: <19f34abd0805071221o236c8629ib184a4720f178e7b@mail.gmail.com>
Date: Wed, 7 May 2008 21:21:24 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Cc: "Lin Ming" <ming.m.lin@intel.com>, "Bob Moore" <robert.moore@intel.com>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4820C56C.6070204@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805060909q635d2d43j9414e5f179c9e22f@mail.gmail.com>
	 <84144f020805061338yd6e3declaf5ff9ca344c28ba@mail.gmail.com>
	 <19f34abd0805061346q4af7e4f8kd65009f8d3021d0e@mail.gmail.com>
	 <4820C56C.6070204@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 6, 2008 at 10:54 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
> Vegard Nossum wrote:
>
> > On Tue, May 6, 2008 at 10:38 PM, Pekka Enberg <penberg@cs.helsinki.fi>
> wrote:
> >
> > > On Tue, May 6, 2008 at 7:09 PM, Vegard Nossum <vegard.nossum@gmail.com>
> wrote:
> > >  >  Running kmemcheck on top of v2.6.26-rc1 gives the following (never
> > >  >  before seen) warning:
> > >  >
> > >  >  Linux Plug and Play Support v0.97 (c) Adam Belay
> > >  >  pnp: PnP ACPI init
> > >  >  ACPI: bus type pnp registered
> > >  >  kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
> > >  >
> > >  >  Pid: 1, comm: swapper Not tainted (2.6.26-rc1-00010-g7966e04 #2)
> > >  >  EIP: 0060:[<c027ecaa>] EFLAGS: 00010286 CPU: 0
> > >  >  EIP is at acpi_ps_get_next_arg+0x1b8/0x262
> > >  >  EAX: f7c12ec0 EBX: f7d20428 ECX: f7ca1b00 EDX: 00000001
> > >  >  ESI: 00000049 EDI: f7d20400 EBP: f7c61e38 ESP: c06c9dc8
> > >  >   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > >  >  CR0: 8005003b CR2: f7c46456 CR3: 006ba000 CR4: 000006c0
> > >  >  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > >  >  DR6: ffff4ff0 DR7: 00000400
> > >  >   [<c0119192>] kmemcheck_read+0xe2/0x140
> > >  >   [<c0119326>] kmemcheck_access+0x136/0x1a0
> > >  >   [<c04bd286>] do_page_fault+0x5e6/0x690
> > >  >   [<c04bb2da>] error_code+0x72/0x78
> > >  >   [<c027f991>] acpi_ps_parse_loop+0x4dd/0x7f8
> > >  >   [<c027ee36>] acpi_ps_parse_aml+0xb4/0x332
> > >  >   [<c02802c0>] acpi_ps_execute_method+0x13d/0x20d
> > >  >   [<c027c8a2>] acpi_ns_evaluate+0x10e/0x1b0
> > >  >   [<c0283210>] acpi_ut_evaluate_object+0x51/0x18d
> > >  >   [<c0283406>] acpi_ut_execute_STA+0x22/0x7b
> > >  >   [<c027c18b>] acpi_ns_get_device_callback+0x5a/0x121
> > >  >   [<c027e410>] acpi_ns_walk_namespace+0xf0/0x10c
> > >  >   [<c027c0b5>] acpi_get_devices+0x47/0x5d
> > >  >   [<c068db45>] pnpacpi_init+0x65/0xa0
> > >  >   [<c06735c7>] kernel_init+0x127/0x290
> > >  >   [<c0104cc7>] kernel_thread_helper+0x7/0x10
> > >  >   [<ffffffff>] 0xffffffff
> > >  >  pnp: PnP ACPI: found 17 devices
> > >  >  ACPI: ACPI bus type pnp unregistered
> > >  >
> > >  >  This faulting instruction comes from
> > >  >
> > >  >  $ addr2line -e vmlinux -i c027ecaa
> > >  >  drivers/acpi/parser/psargs.c:694
> > >
> > >  (That's some seriously hairy code in ACPI btw.)
> > >
> > >  Vegard, can you do disassembly for the faulting instruction? I *think*
> > >  it's the "walk_state->op" bit that is hanging to an object that was
> > >  already deleted in the strange loop in acpi_ps_parse_loop() but it
> > >  would be good to have some more data on this.
> > >
> >
> > Of course. This is in fact another image, but the EIP (and indeed
> > EAX...EDX) are exactly the same. I hope this doesn't get mangled too
> > much by gmail. It's a lot, though :-)
> >
>
>  [snip]
>
>
>
> > c027ec9b:       89 45 e4                mov    %eax,-0x1c(%ebp)
> > c027ec9e:       0f 84 9e 00 00 00       je     c027ed42
> <acpi_ps_get_next_arg+0x250>
> > c027eca4:       8b 87 d4 01 00 00       mov    0x1d4(%edi),%eax
> > c027ecaa:       66 81 78 06 2a 5b       cmpw   $0x5b2a,0x6(%eax)
> >
> >       ^--- EIP here
> >
> > Well, at least kmemcheck correctly identifies it as a 16-bit read...
> >
>
>  Aah, I didn't notice it was a 16-bit read. But yeah at offset 6 we have
> 16-bit aml_opcode:
>
>  #define ACPI_PARSE_COMMON \
>         union acpi_parse_object         *parent; \
>         u8                              descriptor_type; \
>         u8                              flags; \
>         u16                             aml_opcode; \
>
>  So walk_state->op probably points to an object that was already free'd.
> Len?

I turned on ACPI logging just in case you can use it for something.
The full log was a whopping 36M, so I grepped for the memory address
in question (actually, "f7c12ec." since the last digit is 0 for the
start of the object and 6 for the ->op). It turns up a few times; in
particular:

 psutils-0177 [F7C5C000] [00] ps_free_op            : Free retval op: f7c12ec0
 psutils-0177 [F7C5C000] [00] ps_free_op            : Free retval op: f7c12ec0

but you should keep in mind that the kmemcheck report will turn up
out-of-line, probably a long time after the actual error. (The
stack-trace and register dump is correct, though.)

I've uploaded the log to here:

http://userweb.kernel.org/~vegard/bugs/20080507-acpi/relevant.txt

The full log is also available at full.txt. I hope it can help.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
