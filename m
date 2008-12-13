Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYLMMEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYLMMEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 07:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYLMME0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 07:04:26 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:61964 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYLMMEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 07:04:25 -0500
Message-ID: <4943A4BC.4060107@inf.tu-dresden.de>
Date: Sat, 13 Dec 2008 13:04:12 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] video: mbp_nvidia_bl: Add support for MacBook 5,
 MacBook Air 2, and MacBook Pro 5
References: <4942CE33.2020403@inf.tu-dresden.de> <20081212205609.GA28485@srcf.ucam.org>
In-Reply-To: <20081212205609.GA28485@srcf.ucam.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Matthew Garrett schrieb:
> On Fri, Dec 12, 2008 at 09:48:51PM +0100, Mario Schwalbe wrote:
>> Known Bugs:
>>     * MacBook Pro 5:
>>          Initial brightness after bootup is the last recently used
>>          brightness (in Mac OSX), while the firmware reports maximum.
>>          Impossible to fix.
> 
> In that case, why not read the firmware value and then set that 
> explicitly on driver load? Having the driver be in sync with the 
> hardware is better than avoiding a brightness change on boot.

that's already the case. the previous code worked like that and the
patch doesn't change that behaviour. however, the problem is:
(1) the driver tries to read the current setting which is always maximum,
    even through the actual brightness might be lower.
(2) afterwards the driver re-sends this value to hardware effectively
    setting the (visible) brightness to maximum. now hardware and software
    are consistent. that's a brightness change on boot we cannot avoid.

not re-sending the read value on boot is no solution either because if
the user later decides to adjust brightness incrementally (by means of
functions keys) it would immediately jump to some value near maximum
with his adjustment applied. then after the first change, the state
would be consistent.

>> +static int intel_chipset_get_intensity(struct backlight_device *bd)
>>  {
>>  	outb(0x03, 0xb3);
>>  	outb(0xbf, 0xb2);
>>  	return inb(0xb3) >> 4;
>>  }
> 
> Just to absolutely clarify, this is intel chipset as in motherboard 
> chipset and not graphics chipset, right? A comment to make that clear 
> would be good - it left me a little confused at first. Other than that, 
> it looks good.

yes, *_chipset refers to the motherboard chipset vendor.

ciao,
Mario

-- 
 Wo das Chaos auf die Ordnung trifft, gewinnt meist das Chaos,
 weil es besser organisiert ist.
     - Friedrich Nietzsche -

--
    _____    ________
   /     \  /   ____/  Mario Schwalbe
  /  \ /  \ \____  \
 /    Y    \/       \  eMail: schwalbe@inf.tu-dresden.de,
 \____|__  /______  /         ms790178@inf.tu-dresden.de
         \/       \/

          key ID: 7DA9 DAFF
      public key: https://www1.inf.tu-dresden.de/~ms790178/key.asc
 key fingerprint: 2979 AA20 4A93 B527 90CC  45E5 4B28 511A 7DA9 DAFF
