Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXCZG6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXCZG6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933641AbXCZG6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:58:22 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:1661
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933640AbXCZG6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:58:21 -0400
Message-Id: <46078B46.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 26 Mar 2007 07:58:46 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Kevin P. Fleming" <lkml@kpfleming.us>, "Greg KH" <greg@kroah.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot
	adjust BAR0 (not I/O)' on NVidia MCP51
References: <460693EB.9080203@kpfleming.us>
 <20070325161144.GA12155@kroah.com>
In-Reply-To: <20070325161144.GA12155@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Greg KH <greg@kroah.com> 25.03.07 18:11 >>>
>On Sun, Mar 25, 2007 at 08:23:23AM -0700, Kevin P. Fleming wrote:
>> I just upgraded from 2.6.20.2 to 2.6.20.4 on my Compaq V6000 laptop,
>> which has an NVidia core chipset. It has the MCP51 and uses it for PATA
>> and SATA.
>> 
>> Booting the 2.6.20.4 kernel causes two messages (and a kernel lockup)
>> like this:
>> 
>> 0000:00:0d.0: cannot adjust BAR0 (not I/O)
>> 0000:00:0d.0: cannot adjust BAR1 (not I/O)
>> 
>> Booting without ACPI, without APIC, without LAPIC makes no usable
>> difference (although sometimes I will also receive a message about BAR2).
>> 
>> This patch:
>> 
>>
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ed8ccee0918ad063a4741c0656fda783e02df627;hp=9e5755bce00bb563739aeb0f09932a1907521167

>> 
>> is the cause... backing it out results in a working 2.6.20.4 kernel on
>> my laptop.
>> 
>> I'll be happy to provide any assistance I can debugging this problem.
>
>Jan, any thoughts about this?
>
>Should this be backed out of the -stable releases?

I don't think so - the message (as Alan also said) tells the user that the
intended adjustment is *not* being done, kind of as a warning. I would
agree, though, that the flags adjustment (namely, adding
IORESOURCE_IO) is somewhat questionable; this isn't a change the
patch did, though, it was that way already before. But otoh with the
legacy flag set in progif, these BARs *should* be I/O ones...

Jan

