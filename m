Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYGXMhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYGXMhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYGXMhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:37:42 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:6240 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYGXMhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:37:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <48887783.5000002@tremplin-utc.net>
Date: Thu, 24 Jul 2008 14:37:23 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com>	<20080723174801.GC11009@khazad-dum.debian.net> <48884F04.4070403@tremplin-utc.net> <48887201.8090300@cam.ac.uk>
In-Reply-To: <48887201.8090300@cam.ac.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron schreef:
:
>> * If the accelerometer is soldered on the computer, define once for all 
>> to which _physical_ movement corresponds which axis (eg: a laptop on its 
>> normal position going up has axis Z increasing).
> Agreed, though this is more documentation (and strict enforcement on drivers)
Indeed, it's more about defining conventions. A one page document saying 
to userspace developers how they can expect any accelerometer driver 
will behave is desperately needed. The more conventions, the more all 
the drivers will behave similarly, and the easier it will be for 
userspace programs to be written :-)

>> * Free fall event. Either it's hardware detected, or the accelerometer 
>> infrastructure will detect it in software.
> Hadn't thought of doing that in software - should be relatively straight
> forward, though would involve a fairly large overhead if the intention
> is to detect it fast enough to park hardware etc. (similar to that for
> the ring buffer I guess).  I'll look into getting that done for the next
> version (maybe driver specific for now).
Yes, on a second though, this is a low priority point. If userspace is 
able to know if the hardware has or not freefall detection, it should be 
possible to just implement the software detection in the userspace 
daemon. People might come up with lots of "clever" algorithms for that, 
so it might be better to not do too much in the kernel ;-)


> 
> At the moment the big missing element of the subsystem is an easy way of
> querying what is there. (proc interface similar to that for the input subsystem)
You mean /sys/class/input/, right? Indeed, something inspired by the 
input subsystem should work well.

See you,
Eric
