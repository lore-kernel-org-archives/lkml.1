Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbZFLSEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbZFLSEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbZFLSEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:04:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43877 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbZFLSEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:04:09 -0400
Date: Fri, 12 Jun 2009 20:06:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
Message-ID: <20090612180626.GB18203@uranus.ravnborg.org>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 03:40:32PM +0200, Petr Tesarik wrote:
> The handling of various sections in the VDSO linker script
> looks pretty haphazard. This patch series cleans it up in
> these regards:
> 
>  - improve the coding style
>  - remove superfluous sections
>  - issue a linker error if a section is encountered which
>    is known not to work
>  - check that the .got section is empty, except for the
>    three entries defined by the ABI
>  - discard sections which are not useful to user-space
> 
> Petr Tesarik (8):
>   x86: Adjust the coding style of vdso-layout.lds.S
>   x86: Remove .sdata from the vDSO linker script
>   x86: add .broken section to the vDSO linker script
>   x86: mark altinstr-related sections in vDSO as broken
>   x86: mark some standard sections as broken in a vDSO
>   x86: check the size of GOT in vDSO
>   x86: remove unneeded section from the vDSO
The above looks good.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> 
>   x86: Remove .dynbss from the vDSO linker script
This one I am a little reluctant about as I do not understand
why ld sometimes adds and sometimes does not add this section.
At least judging from the arch specific linker scripts some archs
include it and others do not.

I grepped the binutils source and bfd/elf64-x86-64.c mentions
dynbss several times.
Maybe just adding it to broken would suffice as we would
then be informed it it is used by some ld versions?

	Sam
