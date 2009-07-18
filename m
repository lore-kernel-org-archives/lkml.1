Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZGRSzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZGRSzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZGRSzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:55:06 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38644 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZGRSzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:55:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pi70ex2rWzLqGVX1jm86Jju3uH/XLCUmFktVqunEWpc06T/NwFeNsIzODMpEjV22Gf
         AX6XgH4ZeGNXWh98jOnGhgaNZGsNEYJgBWM4IvWzwMacQcyJ3N8aRE/wBvwHp2T3SdwZ
         cfdLXqbE8t0ywxWb6TvZdS608PpcjIts5cylA=
MIME-Version: 1.0
In-Reply-To: <4A61FE7D.9080409@tuffmail.co.uk>
References: <4A61FE7D.9080409@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 20:55:02 +0200
Message-ID: <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/18 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> I borrowed a HP G7000 last week.  The hp-wmi driver seemed a bit
> confused about hard v.s. soft blocks on the wifi, so I fixed it based on
> acpidump output [1].  I hope this will work on other HP model numbers,
> but it would benefit from testing.  Any volunteers?

HP/Compaq nx6310
2.6.31-rc3+patch

When is enabled by button:
root@gumis:/sys/class/rfkill# ls
rfkill0  rfkill1  rfkill2  rfkill3
root@gumis:/sys/class/rfkill# cat rfkill*/name
phy0
hci0
hp-wifi
hp-bluetooth
root@gumis:/sys/class/rfkill# cat rfkill*/state
1
1
1
1

When disabled by button:
root@gumis:/sys/class/rfkill# ls
rfkill0  rfkill2  rfkill3
root@gumis:/sys/class/rfkill# cat rfkill*/name
phy0
hp-wifi
hp-bluetooth
root@gumis:/sys/class/rfkill# cat rfkill*/state
2
1
0

I enable again by button:
root@gumis:/sys/class/rfkill# ls
rfkill0  rfkill2  rfkill3  rfkill4
root@gumis:/sys/class/rfkill# cat rfkill*/name
phy0
hp-wifi
hp-bluetooth
hci0
root@gumis:/sys/class/rfkill# cat rfkill*/state
1
1
1
1

I disable "by software" in Windows XP (bluetooth and wireless):
root@gumis:/sys/class/rfkill# ls
rfkill0  rfkill1  rfkill2  rfkill3
root@gumis:/sys/class/rfkill# cat rfkill*/name
phy0
hp-wifi
hp-bluetooth
hci0
root@gumis:/sys/class/rfkill# cat rfkill*/state
2
0
1
1

Bluetooth works fine when I back to Linux, it seems be enabled during
boot. Wireless is disabled. I cannot connect to network. So I
re-enable it in Windows:
root@gumis:/sys/class/rfkill# ls
rfkill0  rfkill1  rfkill2  rfkill3
root@gumis:/sys/class/rfkill# cat rfkill*/name
phy0
hci0
hp-wifi
hp-bluetooth
root@gumis:/sys/class/rfkill# cat rfkill*/state
1
1
1
1

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
