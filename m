Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZEJPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZEJPNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZEJPNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 11:13:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43914 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbZEJPNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 11:13:04 -0400
Date: Sun, 10 May 2009 17:18:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
Message-ID: <20090510151804.GE23223@one.firstfloor.org>
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com> <4A03F016.76EA.0078.0@novell.com> <874ovvo0wo.fsf@basil.nowhere.org> <4A0492EA.6080403@zytor.com> <20090508205347.GC23223@one.firstfloor.org> <4A049B99.4000402@zytor.com> <20090509100008.GD23223@one.firstfloor.org> <4A06778E.9030908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A06778E.9030908@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 11:43:26PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> However, as far as querying SRAT, I don't like the idea of spreading the 
> >> knowledge of the system memory map out between a bunch of different 
> >> places, each of which have a little piece of the puzzle.  It puts a huge 
> >> onus on the user to know what mechanisms are actually available, and 
> >> really makes a shitty interface.
> > 
> > AFAIK another popular OS always combines mappings from all sources (e820,
> > SRAT, PCI, PNP, ACPI etc.) in the query before allocating anything.
> > Something like that might be a reasonable long term direction for Linux
> > too, but it's probably also a can of worms to handle the conflicts
> > between the various sources (e.g. e820 reserves a lot of things
> > in other sources too). It would be a rather large change.
> > Maybe that would handle the systems I thought of above.
> 
> You *always* have a conflict resolution policy... whether or not it is

Well right now we ignore ACPI/PNP data, sometimes ignore PCI data 
and only look in e820 and sometimes only use PCI/e820 and sometimes
only use SRAT (or at least it was like this at some point)

BTW SRAT hot range can be also wrong, some BIOS always had a full
512GB range even though they don't support hotplug.
However I haven't seen a system which supports hotplug (not that
there are very many of those) where the entry was not there, so at least
that one should be safe.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
