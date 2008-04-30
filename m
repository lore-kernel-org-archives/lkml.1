Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbYD3DQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbYD3DQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYD3DQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:16:04 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:52846 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYD3DQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:16:03 -0400
Date: Tue, 29 Apr 2008 20:13:58 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Ben Nizette <bn@niasdigital.com>
cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
In-Reply-To: <1209521291.311.99.camel@moss.renham>
Message-ID: <Pine.LNX.4.64.0804292003440.24287@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net>  <200804291455.39674.david-b@pacbell.net>
  <1209511772.311.55.camel@moss.renham>  <200804291804.19518.david-b@pacbell.net>
 <1209521291.311.99.camel@moss.renham>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, Ben Nizette wrote:
>> On Tuesday 29 April 2008, Ben Nizette wrote:
>>> I guess one last option (which is made hard by chip label non-uniqueness
>>> but I'll throw out anyway) would be
>>>
>>> /sys/class/gpio
>>>         /chipa
>>>                 /gpio-n
>>>                         /value
>>>                         /direction
>>>                 /control
>>>         /chipb
>>>                 :
>>>                 :
>>>
>>
>> Or maybe:
>>
>>   /sys/class/gpio
>> 	/gpiochip-X			<-- range X..(X+ngpio)
>> 		/device			<-- symlink, if it's known
>> 		/ngpio
>> 		/label
>> 		/start			<-- maybe; start == X
>>
>> with the gpio-N links probably going where you showed.  That'd be
>> best in terms of Purity Of Essence.
>
> So you're suggesting that the gpio-N links and control file live inside
> the gpiochip-X folder along with info about the chip to which they're
> attached?  I don't mind this, sounds good.  Certainly feels most
> sysfsish.
>
> Scripting would be pretty simple assuming there's one control file per
> chip and the gpio number written to said control file is relative to
> that chip's base.  i.e. finding pcf9557:5 (assuming only one such
> device) would just be
>
> - find the gpiochip-X folder whose /label == pcf9557
> - echo "export 5" > <that_folder>/control
> - read/write <that_folder>/gpio-5/{value,direction}

I don't suppose you could actually write the code to do this?

I already wrote the code, and am using it, for the way I have it work.

cat /sys/class/gpio/pcf9557-0:5

But I guess this is too easy.  "We can't have any of that!!  The Earth will
turn in its grave!  And Slashdot will be decorated in Pink!  Teh End Daze
arrive!  :)"

