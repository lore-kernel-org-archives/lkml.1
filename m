Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXEFW6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXEFW6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXEFW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:58:33 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55041 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXEFW6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:58:32 -0400
Message-ID: <463E5D94.10200@simon.arlott.org.uk>
Date: Sun, 06 May 2007 23:58:28 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] dvb-core: Handle failures to create devices
References: <463774FE.9030104@simon.arlott.org.uk> <Pine.LNX.4.58.0705011418130.309@shell2.speakeasy.net> <4637B210.5040302@simon.arlott.org.uk> <Pine.LNX.4.58.0705061404170.32689@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0705061404170.32689@shell2.speakeasy.net>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/07 23:50, Trent Piepho wrote:
> I've tested this and can confirm it works.  dvb_class will be set too late
> without the change to subsys_initcall.
> 
> On Tue, 1 May 2007, Simon Arlott wrote:
>> dvb-core is not started early enough when device drivers that use dvb are
>> compiled in so device_register_device fails (silently) since dvb_class is
> 
>                 ^dvb_register_device
> 
>> NULL, this runs dvb_init using subsys_initcall instead of module_init.
>>
>> dvb_register_device will now check the return value of class_device_create.
>> All the printks had missing level prefixes so I've fixed these too.
> 
> Probably better to make this a separate patch, since it's not related.
> 
>> -		printk ("%s: could get find free device id...\n", __FUNCTION__);
>> +		printk(KERN_ERR "%s: could get find free device id...\n", __FUNCTION__);
> 
> "couldn't find free device id"
> 
> If it's ok with you, I'll import your patch as two seperate patches with
> the spelling errors fixed?

That's fine with me.
 
>> +	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
>>  		adap->num, dnames[type], id, nums2minor(adap->num, type, id),
>>  		nums2minor(adap->num, type, id));
> 
> The dvb-core dvbdev_debug parameter does nothing but turn on this one
> single dprintk.  I'm tempted to just delete it.

Just always output that information, or remove it? (I have it enabled, 
although I'm not sure if there's any point).

-- 
Simon Arlott
