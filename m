Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZGAA0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZGAA0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZGAA0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:26:30 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:64380 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZGAA0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:26:30 -0400
X-IronPort-AV: E=Sophos;i="4.42,319,1243828800"; 
   d="scan'208";a="3271410"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: RFC - printk handling more than one CON_BOOT
Date: Tue, 30 Jun 2009 20:29:36 -0400
User-Agent: KMail/1.9.5
CC: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Paul Mundt" <lethal@linux-sh.org>
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <200906301905.13095.rgetz@blackfin.uclinux.org> <20090630231457.GB17968@elte.hu>
In-Reply-To: <20090630231457.GB17968@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906302029.36962.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Jul 2009 00:26:18.0974 (UTC) FILETIME=[8D904FE0:01C9F9E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Jun 2009 19:14, Ingo Molnar pondered:
> > > Why not have a state variable that tells us whether we are in
>  > > the early boot phase or not and warn about early consoles that
>  > > get registered too late and real consoles that get registered
>  > > too early?
>  >
>  > That makes sense to me. Today - there are some bootconsoles (x86
>  > and sh) that accept a "keep" - still register early - but don't
>  > set the CON_BOOT, so they get treated like a normal console (but
>  > are hooked up before console_init()).
>  >
>  > This would not allow that to happen.... - is that really desired?
>  
>  Hm, i actually rely on 'earlyprintk=...,keep' myself sometimes.
>  
>  I should really have noticed that ;-)
>  
>  'keep' is really useful for some of the nastiest of crashes: where
>  we crash so hard and so fast that regular printk has no chance/time
>  to print something useful. On more than one occasion i got the
>  un-fancy early-printk stuff give me a vital clue before the kernel
>  crapped up - while normal printk wouldnt.
>  
>  So you are right - we need an iteration over early consoles and
>  shuffle the keep-ones into the real console list, right?

My limited understanding is that the only difference between a "standard" 
console, and a bootconsole is the flag CON_BOOT.

boot consoles get added as normal (in register_console()), then removed from 
the console list (in unregister_console()) already - don't they? 



The other thing I forgot to do was update disable_boot_consoles() - that is 
fixed now too.

-Robin

