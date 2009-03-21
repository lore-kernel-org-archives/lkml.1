Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbZCUKJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbZCUKJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZCUKJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:09:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZCUKJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:09:29 -0400
Date: Sat, 21 Mar 2009 11:09:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Hancock <hancockrwd@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Christopher Schramm <debian@shakaweb.org>, linux-kernel@vger.kernel.org
Subject: Re: APIC problem report
Message-ID: <20090321100914.GE7201@elte.hu>
References: <49C1FE7D.9070605@shakaweb.org> <49C4384A.5030802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C4384A.5030802@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Hancock <hancockrwd@gmail.com> wrote:

> Christopher Schramm wrote:
>> Hi,
>>
>> I found a problem with APIC on a desktop PC equipped with Asus' M2N,  
>> running the manufacturer's AMI BIOS - version 0803.
>>
>> I've tried booting Knoppix 5.3.1 (Kernel 2.6.24.4) and GParted live  
>> (Debian's 2.6.26-13). Both will only boot if noapic parameter is used.
>> Otherwise I get "MP-BIOS bug: 8254 timer not connected to IO-APIC"  
>> resulting in a kernel panic.
>>
>> apic=debug gives "ACPI: Core revision 20080321", "Version 80050010"  
>> (twice), "ID: 0", "LVT0: 700", "LVT1:400" and "ESR value before 
>> enabling vector: 0x00000004  after: 0x00000000".
>>
>> Hope it's of some use (and the best place to report it)
>>
>> Christopher
>
> Try booting with acpi_use_timer_override kernel parameter. The 
> problem is likely the same one that shows up on my Asus A8N-SLI 
> Deluxe with the latest 1805 BIOS. The kernel ignores ACPI timer 
> overrides on NVIDIA chipsets since they have historically been 
> broken, however in later BIOS versions this has been fixed and the 
> override is now apparently required for the 8254 timer to function 
> properly through the IO-APIC.
>
> That problem is still there in newer kernels, but it's not fatal 
> since the kernel just routes the timer through the PIC instead..

Correct. Warning messages in this area are OK as long as the system 
ends up booting and working fine. What we would be interested in 
fixing is latest kernels not booting out of box at all - i.e. 
requiring noapic parameter or other quirks.

	Ingo
