Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbZINSZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbZINSZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933059AbZINSZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:25:31 -0400
Received: from zm1.veloxia.com ([213.149.227.2]:60826 "HELO zm1.veloxia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933038AbZINSZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:25:28 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 14:25:27 EDT
Message-ID: <4AAE8908.1000104@hvsistemas.es>
Date: Mon, 14 Sep 2009 20:18:48 +0200
From: Javier Herrero <jherrero@hvsistemas.es>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] input/keyboard: new OpenCores Keyboard Controller
 	driver
References: <1252911864-19233-1-git-send-email-vapier@gentoo.org> 	<1252950003-9451-1-git-send-email-vapier@gentoo.org> <200909141049.50705.dmitry.torokhov@gmail.com> <8bd0f97a0909141102l5fa309f4ua1bedd0f1ac99295@mail.gmail.com>
In-Reply-To: <8bd0f97a0909141102l5fa309f4ua1bedd0f1ac99295@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It has a bit long since last time I touched the driver, so I should also 
try to refresh my memory about it :). I suppose that you're right in the 
double allocation issue (I took another keyboard driver as a starting 
point and probably the double allocation was already there...), so feel 
free to introduce the change and I will test it as soon as I can.

About the exact scancode - key mapping, the reason is that since the 
FPGA opencores device already implements a translation table, I found 
that another translation table sounded a bit redundant.

Best regards,

Javier

Mike Frysinger escribió:
> On Mon, Sep 14, 2009 at 13:49, Dmitry Torokhov wrote:
>> On Monday 14 September 2009 10:40:03 am Mike Frysinger wrote:
>>> +struct opencores_kbd {
>>> +     struct input_dev *input;
>>> +     struct resource *addr_res;
>>> +     struct resource *irq_res;
>>> +     unsigned short *keycode;
>>> +};
>> Why do we allocate keycode table separately form the main structure?
>
> the double alloc looked a little funny, but i didnt dive deep into the
> details.  but as you point this out, it seems to make sense to me.
> any problems with that change Javier ?
>
> i.e. we do:
> struct ... { ... unsigned short keycode[NUM_KEYS]; }
> rather than doing two calls to kmalloc
>
>> I think I still have some reservations with the notion that we can just
>> have exact "scancode" - KEY_* mapping and hardware producers will adjust
>> the hardware to follow the deriver but I guess it's OK...
>
> considering this is a piece of "hardware" implemented in FPGAs, i
> think it's ok too.  if someone really needs more flexibility, then
> they're free to extend the driver and submit a patch :).
> -mike
>
>

-- 
------------------------------------------------------------------------
Javier Herrero                            EMAIL: jherrero@hvsistemas.com
HV Sistemas S.L.                          PHONE:         +34 949 336 806
Los Charcones, 17A                        FAX:           +34 949 336 792
19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com

