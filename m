Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYD2Jrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYD2Jrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYD2Jrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:47:31 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:46446 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYD2Jra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kUCAHzDMmiUfgSKL7BeMSgfb+4olidtoJc2Kml17tmjPHjmFhU8IXpfU/VRA7JzGTW7KqrzYPy40A39eKU/GsDbT1uDtehbPxoDzN+UJ06NCcJ0LuRTzQFd00OcRlBx0GeKDR2cPy9cQx08Ae6khCCcrMcnOleo9vX5TwKafjk4=
Message-ID: <4816EEA1.6050804@googlemail.com>
Date: Tue, 29 Apr 2008 11:47:13 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: yhlu.kernel@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete
 layout v7
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804281316.14168.yhlu.kernel@gmail.com> <200804281505.05764.yhlu.kernel@gmail.com> <200804290200.33459.yhlu.kernel@gmail.com>
In-Reply-To: <200804290200.33459.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> some BIOS like to use continus MTRR layout, and may X driver can not add
> WB entries for graphical cards when 4g or more RAM installed.
> 
> the patch will change MTRR to discrete.
> 
> mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
> default is 256m, could be set according to size of graphics card memory.
> 
> v2: fix -1 for UC checking
> v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>     skip the var state change warning.
>     remove next_basek in range_to_mtrr()
> v4: correct warning mask.
> v5: CONFIG_MTRR_SANITIZER
> v6: fix 1g, 2g, 512 aligment with extra hole
> v7: gran_sizek to prevent running out of MTRRs.
> 

With this version ( and patch http://lkml.org/lkml/2008/4/29/97 ) applyed on latest linus git tree
the box OOPS'es early.

Sorry I don't have time right now to write down the part of the OOPS I can see on monitor , I can try to find
some time later.

In any way OOPS'es on __free_one_page+0x191/0x21e


Gabriel
