Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZGRUq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZGRUq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 16:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZGRUqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 16:46:25 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54356 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZGRUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 16:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PGZCU1ssv0tzW8p4xInh5jxFLweQhSPy0Ux2ZO6Qh4/JjU4VX1rpydi9f9TL9RhCot
         n/ODLwJIUGay6uzRGmt3C++I+WWVDC01q7Wg/efQw5UpiUxPCakzeLJWGYpXnTUkChCL
         4KyazEm52yYaedZybNDyhLON1ICI9TDs6NM4A=
Message-ID: <4A623490.50305@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 21:46:08 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
References: <4A61FE7D.9080409@tuffmail.co.uk> <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>
In-Reply-To: <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/7/18 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>   
>> I borrowed a HP G7000 last week.  The hp-wmi driver seemed a bit
>> confused about hard v.s. soft blocks on the wifi, so I fixed it based on
>> acpidump output [1].  I hope this will work on other HP model numbers,
>> but it would benefit from testing.  Any volunteers?
>>     
>
> HP/Compaq nx6310
> 2.6.31-rc3+patch
>
> When is enabled by button:
> root@gumis:/sys/class/rfkill# ls
> rfkill0  rfkill1  rfkill2  rfkill3
> root@gumis:/sys/class/rfkill# cat rfkill*/name
> phy0
> hci0
> hp-wifi
> hp-bluetooth
> root@gumis:/sys/class/rfkill# cat rfkill*/state
> 1
> 1
> 1
> 1
>
> When disabled by button:
> root@gumis:/sys/class/rfkill# ls
> rfkill0  rfkill2  rfkill3
> root@gumis:/sys/class/rfkill# cat rfkill*/name
> phy0
> hp-wifi
> hp-bluetooth
> root@gumis:/sys/class/rfkill# cat rfkill*/state
> 2
> 1
> 0
>
> I enable again by button:
> root@gumis:/sys/class/rfkill# ls
> rfkill0  rfkill2  rfkill3  rfkill4
> root@gumis:/sys/class/rfkill# cat rfkill*/name
> phy0
> hp-wifi
> hp-bluetooth
> hci0
> root@gumis:/sys/class/rfkill# cat rfkill*/state
> 1
> 1
> 1
> 1
>
> I disable "by software" in Windows XP (bluetooth and wireless):
> root@gumis:/sys/class/rfkill# ls
> rfkill0  rfkill1  rfkill2  rfkill3
> root@gumis:/sys/class/rfkill# cat rfkill*/name
> phy0
> hp-wifi
> hp-bluetooth
> hci0
> root@gumis:/sys/class/rfkill# cat rfkill*/state
> 2
> 0
> 1
> 1
>
> Bluetooth works fine when I back to Linux, it seems be enabled during
> boot. Wireless is disabled. I cannot connect to network. So I
> re-enable it in Windows:
> root@gumis:/sys/class/rfkill# ls
> rfkill0  rfkill1  rfkill2  rfkill3
> root@gumis:/sys/class/rfkill# cat rfkill*/name
> phy0
> hci0
> hp-wifi
> hp-bluetooth
> root@gumis:/sys/class/rfkill# cat rfkill*/state
> 1
> 1
> 1
> 1
>
> Regards
>   

Great detail!  That all fits with what I was expecting.

Linux can also do enabling "by software".  At the moment, you need to
download and compile a utility to poke /dev/rfkill.  I wouldn't bother
testing it, because I didn't change that bit :-).

I'll try extending this to bluetooth and wwan as Matthew suggested.  If
you have time to run "acpidump" and send me the output, that would help
me check the details.

Thanks for volunteering :-)
Alan
