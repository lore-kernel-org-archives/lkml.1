Return-Path: <linux-kernel-owner+w=401wt.eu-S935205AbYEUPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205AbYEUPtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbYEUPte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:49:34 -0400
Received: from [83.228.35.12] ([83.228.35.12]:34664 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbYEUPtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:49:33 -0400
References: <courier.4832011A.000041C2@fs.ru.acad.bg>
            <1211248108.19834.2.camel@sli10-desk.sh.intel.com>
            <courier.4832F7AF.00000DCD@fs.ru.acad.bg>
            <1211360320.22210.5.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1211360320.22210.5.camel@sli10-desk.sh.intel.com>
From: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Luca Tettamanti <kronos.it@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] pata_jmicron: no drives found on post 2.6.25
  kernels
Date: Wed, 21 May 2008 18:49:31 +0300
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Message-ID: <courier.4834448B.00007204@fs.ru.acad.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li написа: 

> On Tue, 2008-05-20 at 19:09 +0300, Plamen Petrov wrote:
>> Shaohua Li написа:  
>> 
>> > On Tue, 2008-05-20 at 01:37 +0300, Plamen Petrov wrote:
>> >> Hello, folks!  
>> >> 
>> >> After 2.6.26 merge window opened, the optical drives in my
>> >> computer, hanging off a JMicron controler were not detected
>> >> by linux any more.  
>> >> 
>> >> Luca Tettamanti reported similar troubles:
>> >> http://marc.info/?l=linux-kernel&m=120958791323911&w=2  
>> >> 
>> >> Its been 20 days, so I decided to bisect.
>> >> git bisect revealed that commit
>> >> 7d715a6c1ae5785d00fb9a876b5abdfc43abc44b
>> >> is the one causing pata_jmicron to fail to detect drives,
>> >> connected to the JMicron controler on my motherboard.
>> >> At least in my case, anyway...
>> >> Changing kernel config to CONFIG_PCIEASPM=n makes the drives
>> >> attached to the JMicron SATA/PATA controller usable again. 
>> > When you enable this option, did you change any ASPM policy? By default,
>> > we are using the BIOS setting, so it shouldn't change any thing. 
>> >  
>> 
>> No, I did not change any ASPM policy, mainly because I do not how.  
>> 
>> > Also can you please send me the 'lspci -vvvxxxx' output with/without the
>> > ASPM enabled? 
>> > 
> Can you please try below patch?
> The Slot 03:00.* of JMicron controller has two functions, but one is
> PCIE endpoint the other isn't PCIE device, very strange. PCIE spec
> defines all functions should have the same config for ASPM, so disable
> ASPM for the whole slot in this case. 
> 

With the provided patch applied on top of latest git tree, the optical
drive connected to the JMicron controller WORKS with CONFIG_PCIEASPM=y. 

Just in case - this is on a Gigabyte GA-P35-DS3R v2.1 motherboard,
BIOS F11. 

Thanks! 


Plamen Petrov, network & system administrator
Filial - Silistra
RU "Angel Kantchev"
http://fs.ru.acad.bg/
 --------------------------------
this message is UTF8 encoded 

_
___
_____
 ------------------------------------------
This message was sent by the mail server
at fs.ru.acad.bg using the web interface:
    https://fs.ru.acad.bg/s/m/webmail
E-mail postmaster@fs.ru.acad.bg with anything,
regarding the server itself
