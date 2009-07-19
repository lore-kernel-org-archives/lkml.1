Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZGSIPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZGSIPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 04:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZGSIPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 04:15:38 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:61061 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZGSIPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 04:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M9eVNn4wGyIlz3ER9rZbjWdqolhWii5c3sTVYBh41pMbNJKMjYWbO38IECOBnKYWVo
         rIN1a2JZ6cpBxDJa30ZcPNeyVSFY052Yyf3O7k3GW/M9BwVq6tUZxHKLiWilMvAikk7+
         CnmYBroDPNo7XpDHQM0/IyF8JPLC2Lvshi2rQ=
MIME-Version: 1.0
In-Reply-To: <71cd59b00907181437l6ef362ejc345818a5197a6c4@mail.gmail.com>
References: <4A61FE7D.9080409@tuffmail.co.uk>
	 <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>
	 <4A623490.50305@tuffmail.co.uk>
	 <71cd59b00907181437l6ef362ejc345818a5197a6c4@mail.gmail.com>
Date: Sun, 19 Jul 2009 10:15:32 +0200
Message-ID: <8db1092f0907190115l6c55df77o47ae40c20b04c2a6@mail.gmail.com>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/18 Corentin Chary <corentin.chary@gmail.com>:
>> Linux can also do enabling "by software".  At the moment, you need to
>> download and compile a utility to poke /dev/rfkill.  I wouldn't bother
>> testing it, because I didn't change that bit :-).
>
> Utility is here
> http://git.sipsolutions.net/?p=rfkill.git
> And a patch to restore write access to /sys/class/rfkill/*/state file is here
> http://lkml.org/lkml/2009/7/10/339

Great tool.

Block bluetooth:
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill block 3
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: yes
        Hard blocked: no

root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill unblock 3
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
5: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no

Block wireless:
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill block 0
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
0: phy0: Wireless LAN
        Soft blocked: yes
        Hard blocked: no
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
5: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill unblock 0
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
5: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
	
Works very nice on my laptop

Thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
