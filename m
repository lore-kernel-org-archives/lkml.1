Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYCHMmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYCHMmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 07:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYCHMl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 07:41:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46499 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYCHMl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 07:41:56 -0500
Date: Sat, 8 Mar 2008 13:43:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Snook <csnook@redhat.com>,
       Andrew Buehler <abuehler.kernel@gmail.com>,
       Frederik Deweerdt <deweerdt@free.fr>, belcampo <belcampo@zonnet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
Message-ID: <20080308124332.GF27074@one.firstfloor.org>
References: <47BE9781.3030304@zonnet.nl> <20080222100630.GE5906@slug> <47D14526.2070103@gmail.com> <47D192BF.5090501@redhat.com> <87zltae3y7.fsf@basil.nowhere.org> <20080308073000.GH8953@1wt.eu> <20080308114655.GB27074@one.firstfloor.org> <20080308123436.GA24982@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308123436.GA24982@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On HT, I normally observe lower performance than on UP.

Hmm weird. It might be interesting to investigate in detail
what is going on there.

> model name      : Intel(R) Core(TM)2 Duo CPU     E8200  @ 2.66GHz
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr lahf_lm

Dual core systems generally have it, It leads to better scheduling
on some older OS because in many aspects dual core is nearer HT than
a true dual socket systems. There was no traditional way to express 
"core siblings" in CPUID so they just faked HT again, but added some 
additional ways to detect real dual coreness. AMD does it similar 
(but slightly different). Of course modern kernels don't need such
hacks anymore. 

-Andi
