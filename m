Return-Path: <linux-kernel-owner+w=401wt.eu-S940420AbXGaBvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940420AbXGaBvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763623AbXGaBvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:51:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763708AbXGaBvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:51:13 -0400
Date: Mon, 30 Jul 2007 18:50:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.23-rc1 REGRESSION] CPU hotplug totally broken on HPC nx6325
 (x86_64)
In-Reply-To: <20070731012340.GD3673@sequoia.sous-sol.org>
Message-ID: <alpine.LFD.0.999.0707301845380.4161@woody.linux-foundation.org>
References: <200707261440.50649.rjw@sisk.pl>
 <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org>
 <20070731012340.GD3673@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Chris Wright wrote:
> 
> This also fixes paravirt patching which was broken when text_poke()
> tried to patch the various pv ops in lookup_address.

Hmm. What is "this"? The revert? 

That said, I do wonder whether virtualization still has problems with 
CONFIG_RODATA, though. We limit the RODATA memory ranges based on KPROBES 
and HOTPLUG_CPU, but not based on VIRTUALIZATION.

I'd expect any virtualization fixups to hit the same problems that the SMP 
alternatives hit. No?

		Linus
