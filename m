Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbXJaAAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbXJaAAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXJ3X75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:59:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340AbXJ3X74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:59:56 -0400
Date: Tue, 30 Oct 2007 16:59:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <4727C126.8070000@shaw.ca>
Message-ID: <alpine.LFD.0.999.0710301653330.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com>
 <200710260959.46811.jbarnes@virtuousgeek.org> <20071027024140.GC29039@kroah.com>
 <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
 <20071030094756.779ac5c0@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
 <4727C126.8070000@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Robert Hancock wrote:
> > 
> > You have to, anyway. Even now the MMCONFIG stuff uses CONF1 cycles for
> > startup.
> 
> If it does, it's not by necessity. As soon as you read the table location out
> of the ACPI tables you can start using it, and that shouldn't require any
> config space accesses.

Don't be silly. Exactly _BECAUSE_ we cannot trust the firmware, we have to 
use conf1 (which we can trust) to verify it and/or fix things up.

Also, there are several devices that don't show up in the MMCFG things, or 
just otherwise get it wrong.

So just take a look at arch/x86/pci/mmconfig-shared.c and look for 
"conf1".

Really. Damn, I'm nervous taking any MMCFG patches that has you as an 
author, if you aren't even aware of these kinds of fundamnetal issues. You 
probably read the standards about how things are "supposed" to work, and 
then just believed them?

Rule #1 in kernel programming: don't *ever* think that things actually 
work the way they are documented to work. The documentation is a starting 
point, nothing else. 

And please be defensive in programming. We *know* conf1 cycles work. The 
hardware has been extensively tested, and there are no firmware 
interactions. There is *zero* reasons to use MMCONF cycles for normal 
devices. Ergo: switching over to MMCONF when not needed is stupid and 
fragile.

			Linus
