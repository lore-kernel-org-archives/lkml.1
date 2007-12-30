Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbXL3Us6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbXL3Us6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXL3Usv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:48:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:53768 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXL3Usu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HE3Afe4hvsmGce1ggp5dYTcVEJry8Rs9KtyWoPe5h9dDSRfe6tHucotoLcdXT4K4ZGlyYp/WK+Z7u3wEj6VrhBlGTFVnEm5F32X2rUGNOm/crK3VArOe9aQq/Yd14v5YfQCIwSK4+g11zllo3zc3W19gUmPad3M3nWH+nl1hBms=
Message-ID: <86802c440712301248m38cd000ejf7e48f273d573edd@mail.gmail.com>
Date: Sun, 30 Dec 2007 12:48:48 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: clear IO_APIC before enabing apic error vector. v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071230145115.GR16946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712291952.20455.yinghai.lu@sun.com>
	 <20071230145115.GR16946@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 6:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
> > please check if you can replace the one in the x86-mm
> >
> > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ffcbdc220a1520d006a837f33589c7c19ffbeb76
> >
> > the updated one avoid one link warning.
>
> please send delta patches instead - so that we can review the changes.

will do that in another patch.

>
> > this is the updated verison that take enable_IO_APIC as extra call for
> > setup_local_APIC to avoid linking warning.
>
> hm, what link warning did you get? Perhaps the following __cpuinit:

WARNING: vmlinux.o(.text+0x163d5): Section mismatch: reference to
.init.text:enable_IO_APIC (between 'setup_local_APIC' and
'apic_is_clustered_box')

>
> > -void __cpuinit setup_local_APIC (void)
>
> does not mix well with an __init call:
>
> > +void __init enable_IO_APIC(void)
>
> and you hack it around by using a function pointer. Nasty and still
> buggy. The proper solution would be to mark enable_IO_APIC as __cpuinit
> too (or something like that).

after change that to __cpuinit, i got

WARNING: vmlinux.o(.text+0x17f84): Section mismatch: reference to
.init.text: (between 'enable_IO_APIC' and 'ioapic_resume')
WARNING: vmlinux.o(.text+0x17f92): Section mismatch: reference to
.init.text: (between 'enable_IO_APIC' and 'ioapic_resume')

YH
