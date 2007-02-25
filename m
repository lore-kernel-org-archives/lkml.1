Return-Path: <linux-kernel-owner+w=401wt.eu-S933633AbXBYCa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633AbXBYCa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 21:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933634AbXBYCa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 21:30:56 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49978 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933633AbXBYCaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 21:30:55 -0500
Message-ID: <45E0F4D1.9080900@lwfinger.net>
Date: Sat, 24 Feb 2007 20:30:41 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 01/18] bcm43xx: Fix for oops on resume
References: <20070221014413.282048309@mini.kroah.org> <20070221014939.GB3684@kroah.com> <20070223052526.GA1889@elf.ucw.cz>
In-Reply-To: <20070223052526.GA1889@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> -stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> There is a kernel oops on bcm43xx when resuming due to an overly tight timeout loop.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> ---
>>  drivers/net/wireless/bcm43xx/bcm43xx.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-2.6.18.7.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
>> +++ linux-2.6.18.7/drivers/net/wireless/bcm43xx/bcm43xx.h
>> @@ -21,7 +21,7 @@
>>  #define PFX				KBUILD_MODNAME ": "
>>  
>>  #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
>> -#define BCM43xx_IRQWAIT_MAX_RETRIES	50
>> +#define BCM43xx_IRQWAIT_MAX_RETRIES	100
>>  
>>  #define BCM43xx_IO_SIZE			8192
> 
> I'm sorry, but this does not look like fixing an oops. It may make it
> go away for you, or make it less probable, but it certainly can't fix
> it.

Upon resume, it was taking 65 times through the loop, which caused an oops. We think it is due to a
slow-clock setting at that point, but it certainly does get rid of the oops. This change has also
eliminated the odd oops seen by a few users.

Larry
