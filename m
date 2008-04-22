Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbYDVBZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbYDVBZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbYDVBZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:25:44 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:48363 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761610AbYDVBZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:25:43 -0400
Date: Mon, 21 Apr 2008 19:27:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI MAINTAINER change
In-reply-to: <fa.JwWRxW97po7bp7uP8gASvgGakFc@ifi.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <480D3F0C.9090606@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.TS+5+HinmGrscLiHGCM7C9dFSbk@ifi.uio.no>
 <fa.EEEat9giRPyWOGUiYHgSIStt6vw@ifi.uio.no>
 <fa.zR5oiQ1hgiLPwoqLOEK2ySOHKLA@ifi.uio.no>
 <fa.vh1MNsau5uBs7WyWWCN0Huvxe98@ifi.uio.no>
 <fa.JwWRxW97po7bp7uP8gASvgGakFc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Mon, 21 Apr 2008, Jesse Barnes wrote:
>>> And now I get to figure out just how much trouble I've gotten myself into...
>> Mwhahahaaa! Sucker. You'll find out.
>>
>> The good news is that most of the time, the PCI code works fine. The 
>> bad news is that when it doesn't work, it's usually due to something 
>> *really* odd, like some magic motherboard device that has magic 
>> resources that aren't part of the standard PCI resource set and that 
>> clash with some of our resource allocation.
>>
>> And they don't show up in the PnP lists because Windows never put 
>> anything that could clash with them, so there was no reason for the 
>> BIOS engineers to bother.
>>
>> IOW, it's usually almost totally undebuggable crud like "driver X 
>> doesn't work on my machine", and then it turns out that it only 
>> happens on that particular motherboard that is totally identical to 
>> all other motherboards _except_ for that BIOS table not having the 
>> right reserved IO regions.
>>
>> .. and then there's the pluggable PCI stuff, of course. I'm not sure 
>> whether you took that over too. That's a whole different set of 
>> issues.
> 
> that reminds me of the observations about differences between Linux's 
> and Windows's PCI resource allocation stategies, see the bugzilla entry 
> from today below.
> 
> 	Ingo
> 
> ----------------->
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10461
> 
> ------- Comment #6 from linux@tjworld.net  2008-04-18 11:03 -------
> After a few debug printk() runs watching the allocation strategy I wondered why
> the PCI resources region doesn't start at the beginning of the largest gap:
> 
> [    0.000000] Allocating PCI resources starting at c2000000 (gap:
> c0000000:20000000)
> 
> since, when 3GB RAM is installed, the gap starts at 0xC0000000 but the
> allocation region begins at 0xC2000000.
> 
> The other issue is that only the largest gap seems to be used for allocations,
> which explains why smaller allocations for other devices effectively choke off
> use of the range in 32-bit address space.
> 
> In contrast, from looking at the addresses in the allocation comparison with
> Windows, it looks as if Windows uses *all* gaps for allocation rather than just
> the largest. It is noticeable that Windows allocates smaller regions in the
> gaps between the various 'high' e820 reservations.

I think the reason for this being needed in the first place was in the 
old days we didn't honor the ACPI reserved motherboard resources, or did 
only for certain resource types (and we still have problems with this, 
like the hard-coded limit on max number of PnPACPI resources that's hit 
by many boards and which results in us ignoring some of the BIOS 
reservations). Once that junk is fixed, hopefully we won't have to worry 
about such problems.
