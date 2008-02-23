Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbYBWJIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbYBWJIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYBWJIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:08:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:60963 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbYBWJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=I+7FBeqTDGIGzEvtZJ28jesskEqOpY8br1ZePaIYhvne0NFelZtDNGIm4ictpcAXA162SE6ugR7rtAFLzskGVfgYz3CrVwyOFZiOgoec8KnxjBgvGyK/EDdiCJHhuoNQIc/FEy4G4G2rr3iRDWsk5oYOtJc4GYKM2hJ7tVRHtzc=
Date: Sat, 23 Feb 2008 12:07:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] x86 - boot/header.S
Message-ID: <20080223090739.GB6747@cvg>
References: <20080223082026.GA6747@cvg> <86802c440802230044sbfc909t656aadf5729b31c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802230044sbfc909t656aadf5729b31c2@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sat, Feb 23, 2008 at 12:44:49AM -0800]
| On Sat, Feb 23, 2008 at 12:20 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > Hi Peter, Sam,
| >
| >  could you take a look on x86/boot/header.S:280 please?
| >
| >  # Zero the bss
| >         movw    $__bss_start, %di
| >         movw    $_end+3, %cx
| >         xorl    %eax, %eax
| >         subw    %di, %cx
| >         shrw    $2, %cx
| >         rep; stosl
| >
| >  I wonder why is $_end there instead of $__bss_stop?
| >  Well, accroding to vmlinux_32.lsd both _end and __bss_stop
| >  are the same BUT __bss_stop is more convenient methink.
| >  Would it be usefull to change?
| 
| we should have head32.c like head64.c
| and x86_32_start_kernel.
| 
| Eric's patch long time ago...
| 
| YH
| 

Hi Yinghai,

thanks for reply BUT that is not the point (or maybe I miss something).

Look, we only have head64.c - there is no head32.c at all. Both
vmlinux_32/64.lds defines _end exactly the same as __bss_stop. So in
code which DO fillup bss section with zeros the prefered name is
__bss_stop. The only thing I'm trying to say that it would be clean
naming scheme and I think it would help for further review - instead
of searching all over x86 files to find _end definition __bss_stop
tell us WHAT we are zeroing from the code.

		- Cyrill -
