Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZGWTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZGWTgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZGWTgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:36:18 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:37283 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZGWTgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZZC3TyFOhcaT9xbccFGA3Fqa0C9glHKo66UqZVIpzFtsFddvuKF+f9d8dTBrCiD5hE
         iqC4itAd+050zytpa47rsC8j0b769lqCFbIL5oXgXt7M+PGY85gF0jnkB1VmJ2Yy44PU
         Y5i9GrCTAXleQBOtO3qjXFdUwy1aoT6W1RGZE=
MIME-Version: 1.0
In-Reply-To: <4A68AB8F.9020609@tuffmail.co.uk>
References: <4A65A2F9.1060509@tuffmail.co.uk>
	 <8db1092f0907230831w1255d0bey951342fb61b67c1e@mail.gmail.com>
	 <4A68AB8F.9020609@tuffmail.co.uk>
Date: Thu, 23 Jul 2009 21:36:14 +0200
Message-ID: <8db1092f0907231236x54972749p9f535f696c9b008f@mail.gmail.com>
Subject: Re: [PATCH] hp-wmi: improve rfkill support
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>, linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/23 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:

>
> That's a bug.  You're saying this is in -rc4, without applying my patch?

Yes

>
> I think I know exactly what is happening.  Apply my patch, and it will go
> away :-).

Yes. I add Your patch to -rc4 and rfkill works OK:
Enable by button:
root@gumis:/home/maciek# rfkill list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no

Disable by button:
root@gumis:/home/maciek# rfkill list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no

After resume from s2disk:
root@gumis:/home/maciek# rfkill list
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
4: phy1: Wireless LAN
        Soft blocked: no
        Hard blocked: yes

(are some differences after and before s2disk)

Enable by button:
root@gumis:/home/maciek# rfkill list
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
4: phy1: Wireless LAN
        Soft blocked: no
        Hard blocked: no
5: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no

And wifi/bluetooth works without manual enable. Thanks.

>
> I'm not sure this is a new bug though.  It might be triggered by the big
> rfkill rewrite, but I don't see how that could happen.  Can you confirm if
> this happens in 2.6.30?

2.6.30 works OK

>
> Thanks
> Alan
>


Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
