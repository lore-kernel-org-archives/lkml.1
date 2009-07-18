Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZGRVhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZGRVhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 17:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZGRVhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 17:37:53 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:40000 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZGRVhw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 17:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SqrSUO8y27r5CGro8hrhRka8jVUK/7/2AOqzUcF9zuRdL8BZYUVqG2EDdVdWZ1iMd/
         PiLJce8gUbF4gU8Hh/tG4zWk+Gc9Pl/YHFh4ajz+E+3dJBmAA+/ApHOQnDSJ3zVR+ULw
         2JCLELlZhJ/4kJMcw5oPttXbEWERcE+315qGw=
MIME-Version: 1.0
In-Reply-To: <4A623490.50305@tuffmail.co.uk>
References: <4A61FE7D.9080409@tuffmail.co.uk>
	 <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>
	 <4A623490.50305@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 23:37:49 +0200
Message-ID: <71cd59b00907181437l6ef362ejc345818a5197a6c4@mail.gmail.com>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
From: Corentin Chary <corentin.chary@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 10:46 PM, Alan
Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
> Maciej Rutecki wrote:
>> 2009/7/18 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>>
>>> I borrowed a HP G7000 last week.  The hp-wmi driver seemed a bit
>>> confused about hard v.s. soft blocks on the wifi, so I fixed it based on
>>> acpidump output [1].  I hope this will work on other HP model numbers,
>>> but it would benefit from testing.  Any volunteers?
>>>
>>
>> HP/Compaq nx6310
>> 2.6.31-rc3+patch
>>
>> When is enabled by button:
>> root@gumis:/sys/class/rfkill# ls
>> rfkill0  rfkill1  rfkill2  rfkill3
>> root@gumis:/sys/class/rfkill# cat rfkill*/name
>> phy0
>> hci0
>> hp-wifi
>> hp-bluetooth
>> root@gumis:/sys/class/rfkill# cat rfkill*/state
>> 1
>> 1
>> 1
>> 1
>>
>> When disabled by button:
>> root@gumis:/sys/class/rfkill# ls
>> rfkill0  rfkill2  rfkill3
>> root@gumis:/sys/class/rfkill# cat rfkill*/name
>> phy0
>> hp-wifi
>> hp-bluetooth
>> root@gumis:/sys/class/rfkill# cat rfkill*/state
>> 2
>> 1
>> 0
>>
>> I enable again by button:
>> root@gumis:/sys/class/rfkill# ls
>> rfkill0  rfkill2  rfkill3  rfkill4
>> root@gumis:/sys/class/rfkill# cat rfkill*/name
>> phy0
>> hp-wifi
>> hp-bluetooth
>> hci0
>> root@gumis:/sys/class/rfkill# cat rfkill*/state
>> 1
>> 1
>> 1
>> 1
>>
>> I disable "by software" in Windows XP (bluetooth and wireless):
>> root@gumis:/sys/class/rfkill# ls
>> rfkill0  rfkill1  rfkill2  rfkill3
>> root@gumis:/sys/class/rfkill# cat rfkill*/name
>> phy0
>> hp-wifi
>> hp-bluetooth
>> hci0
>> root@gumis:/sys/class/rfkill# cat rfkill*/state
>> 2
>> 0
>> 1
>> 1
>>
>> Bluetooth works fine when I back to Linux, it seems be enabled during
>> boot. Wireless is disabled. I cannot connect to network. So I
>> re-enable it in Windows:
>> root@gumis:/sys/class/rfkill# ls
>> rfkill0  rfkill1  rfkill2  rfkill3
>> root@gumis:/sys/class/rfkill# cat rfkill*/name
>> phy0
>> hci0
>> hp-wifi
>> hp-bluetooth
>> root@gumis:/sys/class/rfkill# cat rfkill*/state
>> 1
>> 1
>> 1
>> 1
>>
>> Regards
>>
>
> Great detail!  That all fits with what I was expecting.
>
> Linux can also do enabling "by software".  At the moment, you need to
> download and compile a utility to poke /dev/rfkill.  I wouldn't bother
> testing it, because I didn't change that bit :-).

Utility is here
http://git.sipsolutions.net/?p=rfkill.git
And a patch to restore write access to /sys/class/rfkill/*/state file is here
http://lkml.org/lkml/2009/7/10/339


> I'll try extending this to bluetooth and wwan as Matthew suggested.  If
> you have time to run "acpidump" and send me the output, that would help
> me check the details.

I have an HP 8710p, so if you want acpidump and test on another
hardware, just ask :).

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
