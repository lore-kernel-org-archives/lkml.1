Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYGVFRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYGVFRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYGVFQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:16:59 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:18377 "EHLO
	pd6mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750869AbYGVFQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:16:58 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=kcuJUqwM-ltUaUeyri4A:9 a=RzgZCpc2PYsV1YRhO7g2D9rDMCsA:4 a=l9iCJtgIvv4A:10 a=GFZTb6icBPAA:10
Message-ID: <48856D32.1070101@sieb.net>
Date: Mon, 21 Jul 2008 22:16:34 -0700
From: Samuel Sieb <samuel@sieb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080706 Fedora/1.1.10-1.fc9 pango-text SeaMonkey/1.1.10
MIME-Version: 1.0
To: Juergen Beisert <jbe@pengutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
References: <48841A92.4020301@sieb.net> <200807210828.56821.jbe@pengutronix.de>
In-Reply-To: <200807210828.56821.jbe@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Beisert wrote:
> Samuel,
> 
> On Montag, 21. Juli 2008, Samuel Sieb wrote:
>> I have a computer here with a CPU that the BIOS identifies as:
>> Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
>>
>> I can't boot any kernel later than 2.6.22 on it.  Anything later either
>> hangs or gives random kernel panics while booting.  I tracked down the
>> problem to a specific commit:
>>
>> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> Yes. My patch makes some chipset tweaks working as expected. Or at least it 
> makes them work. It seems nobody ever tested them before. Remove the 
> following line (or change it to meet your CPU clock frequency):
> 
This system is kind of an embedded one and it's been working fine, so I 
haven't bothered upgrading the OS for a long time.  Once I get this 
working I will be keeping it more up to date.

> linux-2.6.25/arch/x86/kernel/cyrix.c, line 151. Disable this line or change 
> the value 0x04 according to the speed of your CPU. This tweak helps others 
> with random hangs of their system.
> 
I tried various values and various combinations of commenting out lines 
and the only one that worked for me was to comment out the PCR1 line 
just above it.  With that line commented out (or both of them), it 
boots.  I do get a message about the TSC clocksource being unstable, 
which is a new feature as well.  I can only say that in 2.6.14 it was 
fine.  I could do similar tests if you want to know when that started 
happening.
