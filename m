Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZGIV6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZGIV6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZGIV6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:58:39 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:43991 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbZGIV6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HMqdq8f/PvOIH/iTPfpoIuzxuPxZBLemZVzjDC8QTXiW9Siv5HCBeoV8aTN4XjaJ20
         HaopUEkW1PuNT5vOjqeONbyQImVbRh9RFQ2B3lyssMg5o4dolZ8EVYK2kl0xcQTDiTX3
         KRzci6uGp6CN+xyIbXffns59JTcfv/J47jPH4=
MIME-Version: 1.0
In-Reply-To: <20090709141000.584d199a@nehalam>
References: <20090709141000.584d199a@nehalam>
Date: Thu, 9 Jul 2009 14:58:37 -0700
X-Google-Sender-Auth: 1e6ac26a9f996430
Message-ID: <1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
Subject: Re: Clock incorrect on 2.6.31-rc2
From: john stultz <johnstul@us.ibm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 2:10 PM, Stephen Hemminger<shemminger@vyatta.com> wrote:
> My system (desktop Ubuntu 9.0) runs fine with 2.6.30, but with 2.6.31-rc2 it does
> not keep time correctly. Also ntptime reports an error.

Can you better describe how it does not keep time? Is time moving too
slow? too fast?

Could you include output from the following commands with 2.6.31-rc2
(and 2.6.30 if you have the time).
 $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
 $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
 $ dmesg
 $ ntpdc -c peers
 $ ntpdc -c kerninfo

> $ ntptime
> ntp_gettime() returns code 5 (ERROR)
>  time ce00daf1.8e997000  Thu, Jul  9 2009 14:09:05.557, (.557029),
>  maximum error 25016 us, estimated error 16 us
> ntp_adjtime() returns code 5 (ERROR)
>  modes 0x0 (),
>  offset 0.000 us, frequency 7.827 ppm, interval 1 s,
>  maximum error 25016 us, estimated error 16 us,
>  status 0x40 (UNSYNC),
>  time constant 4, precision 1.000 us, tolerance 500 ppm,

The error above just comes from NTP not being in sync.

thanks
-john
