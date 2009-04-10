Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbZDJTRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbZDJTRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbZDJTRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:17:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:57721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbZDJTRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:17:13 -0400
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       josh@freedesktop.org
In-Reply-To: <20090410191334.GA25336@uranus.ravnborg.org>
References: <1239385015.3169.15.camel@ht.satnam>
	 <20090410175545.GB16843@elf.ucw.cz>
	 <20090410191334.GA25336@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 00:46:56 +0530
Message-Id: <1239391016.3169.49.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 21:13 +0200, Sam Ravnborg wrote:
> On Fri, Apr 10, 2009 at 07:55:45PM +0200, Pavel Machek wrote:
> > On Fri 2009-04-10 23:06:55, Jaswinder Singh Rajput wrote:
> > > Impact: fix overflow
> > 
> > > Constant 0x123456789abcdef0 is so big for a long.
> > > So using saved_magic 0x12345678 for both 32 and 64 bit.
> > 
> > Have you tested the patch? I have feeling that this is tested from
> > assembly... Plus it is only set to long constant on 64-bit, so I don't
> > think you are fixing anything. And if your code is correct the
> > variable is write only...
> 
> $ git grep saved_magic
> kernel/acpi/sleep.c:    saved_magic = 0x12345678;
> kernel/acpi/sleep.c:    saved_magic = 0x123456789abcdef0;
> kernel/acpi/sleep.h:extern long saved_magic;
> kernel/acpi/wakeup_32.S:        movl    %cs:saved_magic, %eax
> kernel/acpi/wakeup_32.S:ENTRY(saved_magic)      .long   0
> kernel/acpi/wakeup_64.S:        movq    saved_magic, %rax
> kernel/acpi/wakeup_64.S:ENTRY(saved_magic)      .quad   0
> 
> 
> wakeup_32.S:
>         movl    %cs:saved_magic, %eax
>         cmpl    $0x12345678, %eax
> 
> wakeup_64.S:
>         movq    saved_magic, %rax
>         movq    $0x123456789abcdef0, %rdx
> 
> So patch is obviously bogus.
> 

Sorry, I was confused by this sparse warning on 64 bit box:

CHECK   arch/x86/kernel/acpi/sleep.c
 arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long

atleast I found problem in sparse ;-)

--
JSR



