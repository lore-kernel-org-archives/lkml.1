Return-Path: <linux-kernel-owner+w=401wt.eu-S934473AbXHNS4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473AbXHNS4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbXHNSz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:55:59 -0400
Received: from ns1.suse.de ([195.135.220.2]:50872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626AbXHNSz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:55:57 -0400
To: Hajime Inoue <hinoue@ccsl.carleton.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
	<20070814000956.7c8929dd@the-village.bc.nu>
	<46C1E5F5.9050702@ccsl.carleton.ca>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Aug 2007 21:50:03 +0200
In-Reply-To: <46C1E5F5.9050702@ccsl.carleton.ca>
Message-ID: <p73zm0tnbf8.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hajime Inoue <hinoue@ccsl.carleton.ca> writes:

> Just protecting the table does not stop rootkits.  A highly referenced
> phrack article explains how to bypass the table. 

During .23-pre for some time the kernel text was protected too (that
would have likely stopped that particular attack), but it was
removed because it caused too many problems.

Ultimatively it is useless for security anyways because the page
tables cannot be protected (because there are valid reasons to change
them). If they're not protected any protection can be undone by
changing them or simply creating an alias mapping. Also the Linux
kernel has function pointers in read-write data structures which could
also be used to inject code.

So even with Alan's hypervisor support the whole thing would be still
quite holey.  The argument of raising the bar also doesn't seem very
convincing to me, because attackers reuse code too and it's enough
when someone publishes such code once, then they can cut'n'paste
it into any exploits forever.

In general the .data protection is only considered a debugging
feature. I don't know why Fedora enables it in their production
kernels.

BTW I tested your test case and it works for me on 2.6.23rc3 with
DEBUG_RODATA enabled on i386/PAE. Without DEBUG_RODATA it BUGs, 
but that's because the c_p_a interface is somewhat clumpsy
and expects balanced changes.

-Andi
