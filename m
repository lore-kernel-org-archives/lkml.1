Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYAGQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYAGQDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYAGQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:03:08 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:38806 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbYAGQDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:03:06 -0500
Message-ID: <47824D25.5090005@hauke-m.de>
Date: Mon, 07 Jan 2008 17:02:45 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: Michael Wu <flamingice@sourmilk.net>, linux-kernel@vger.kernel.org,
       Stefano Brivio <stefano.brivio@polimi.it>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 rate control doesn't work
References: <477F9890.5050107@hauke-m.de> <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
In-Reply-To: <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=95C58E7B;
	url=http://www.hauke-m.de/pgp-pubkey.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an other Problem.

iwconfig shows me "Bit Rate=1 Mb/s" the hole time, but I'm able to
download with an average of 440K/s as wget says.

It's with PID rate control algorithm.

--

Hauke Mehrtens

Luis R. Rodriguez wrote:
> On Jan 5, 2008 9:47 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> Hi
>>
>> Now the compat-wireless-2.6 package is working and I get an Internet
>> connection with my rtl8187 based card. (It's on an ASUS P5B Deluxe)
>>
>> I used the compat-wireless-2.6 package for this log, but I have the same
>> problem with the version integrated in kernel 2.6.24-rc6
>>
>> The Access Point is some rooms away so the signal is not the best at my
>> location. When starting the device with no fixed rate it wants to
>> connect with 54MBit/s and as iwconfig says it was successful but I can't
>> ping any device in the wireless LAN. (it's the first part of the log)
>> The rate will not be slowed down it stays fixed at 54MBit/s.
>>
>> After starting the device with rate fixed to 11M I get a connection to
>> the Access Point and iwconfig's output looks the same as without fixed
>> rate, but I'm able to ping the all devices in the network. (second part
>> of the log)
>> Now it slows down the rate to 1MBit/s
> 
> Seems to be the new PID rate control algorithm. I believe Stephano
> (CC'd) was sending some patches for this. Please try changing in
> config.mk
> 
> From this value:
> 
> CONFIG_MAC80211_RC_DEFAULT=pid
> 
> To this:
> 
> CONFIG_MAC80211_RC_DEFAULT=simple
> 
> and let us know how that goes. Oh and linux-kernel is the wrong list
> to use, please just use linux-wireless for future e-mails.
> 
>   Luis
