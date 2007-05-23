Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbXEWWuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbXEWWuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXEWWt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:49:57 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759245AbXEWWtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:49:55 -0400
Date: Wed, 23 May 2007 15:48:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Olivier Galibert <galibert@pobox.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <20070523222443.GA39776@dspnet.fr.eu.org>
Message-ID: <alpine.LFD.0.98.0705231536510.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705231349.56976.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
 <200705231420.26622.jbarnes@virtuousgeek.org>
 <20070523222443.GA39776@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Olivier Galibert wrote:
> 
> Isn't that a mac-intel instant killer?  AFAIK they don't have type1,
> period.

mac-intel are totally standard Intel chipsets. They have all of 
conf1/conf2/mmconfig afaik.

I just happily booted my mac-mini with "pci=nommconf", nothing bad 
happened, and the kernel says

	PCI: Using configuration type 1

and I don't think you even _can_ disable conf1 type accesses: they are 
deep in the Intel chipsets.

Of course, in a virtualized environment, anything can happen. Virtual 
machines prefer mmconf, because you can use page-level remapping to hide 
devices or make pseudo-devices show up by mapping in pages that have 
nothing to do with the true hardware.

So no, I don't think Alan was totally smoking crack when he talked about 
"trusted" computing. Read the above paragraph a few times. (You can do it 
with trapping IO port accesses too, but it's going to cost you a lot, so 
if you want to make a fast but untrustoworthy setup, MMIO is the better 
option).

		Linus
