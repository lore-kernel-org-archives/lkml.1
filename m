Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbYC0R7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbYC0R7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYC0R7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:59:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34119 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYC0R7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:59:45 -0400
Date: Thu, 27 Mar 2008 10:59:12 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: yhlu.kernel@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: add pci=skip_isa_align command lines.
Message-ID: <20080327175912.GA9684@us.ibm.com>
References: <200803270131.18885.yhlu.kernel@gmail.com> <20080327084557.GH15626@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327084557.GH15626@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 09:45:57AM +0100, Ingo Molnar wrote:
> 
> * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
> 
> > [PATCH] x86/pci: add pci=skip_isa_align command lines.
> > 
> > so we don't align the io port start address for pci cards.
> > 
> > also move out dmi check out acpi.c, because it has nothing to do with 
> > acpi. it could spare some calling when we have several peer root 
> > buses.
> 
> i like this feature, and i've applied your patch to x86.git for testing, 
> but i'd like to hear what the ACPI and PCI guys think about this.
> 
> Also, we should try as hard as possible to make it a blacklist instead 
> of a whitelist? It would be cool to support more PCI cards/devices on 
> all new(-ish) systems by default and if we didnt have to maintain the 
> DMI whitelist for eternity. (a whitelist will always be incomplete and 
> will lag behind reality)

Ingo, This is a great idea.  I was the guy that added the whitelist
and ISA alignment avoidance code but have also been concerned about
the headache of keeping whitelist current in mainline and Distro
releases as new systems are introduced.  When I made the change I
assumed (appearently incorrectly) that there were way too many
existing systems requiring the alignment to even consider the
blacklist approach.  Do you have any suggestions on how to identify
systems to include in the blacklist? ...or would we just boldly make
non-alignment the default, provide an empty blacklist, and let
breakage identify those systems that need to be blacklisted?

Thanks.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
