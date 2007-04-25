Return-Path: <linux-kernel-owner+w=401wt.eu-S1031091AbXDYP3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031091AbXDYP3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031093AbXDYP3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:29:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031091AbXDYP27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:28:59 -0400
Message-ID: <462F73A0.40003@zytor.com>
Date: Wed, 25 Apr 2007 08:28:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org> <20070425044813.f83dde4e.akpm@linux-foundation.org>
In-Reply-To: <20070425044813.f83dde4e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> 
> This patch causes oopses after a minute or so running LTP's
> 
> ./testcases/bin/growfiles -W gf16 -b -e 1 -i 0 -L 120 -u -g 4090 -T 100 -t 408990 -l -C 10 -c 1000 -S 10 -f Lgf02_
> 
> on everyone's favoutite Vaio, configured with
> http://userweb.kernel.org/~akpm/config-sony.txt
> 

*BLINK*

This patch only affects the initial page tables, which should have been
thrown out *way* long ago at this point.

Yet they seem to have stuck around.  This is a very bad thing on many
levels, especially since we should have switched the kernel 1:1 area
over to PSE pages a long time ago.

> BUG: unable to handle kernel paging request at virtual address c084fa8c
>  printing eip:
> c0174c46
> *pde = 0042a027
> *pte = 00000000

Touching a non-PSE page which is zero, and quite consistent with being a
remnant from the original page tables.

Methinks this has smoked out a bug in the initial page table setup which
probably has been a performance roadblock for quite some time.

	-hpa
