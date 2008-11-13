Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYKMSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYKMSUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYKMSUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:20:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:9784 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbYKMSU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:20:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vwy5XAOFIrnVVwI8s3zjf+by7WrBjKsYaKyF8rqMG/x95rf9O2yuJ6kPocCjKOOUhl
         LmR6fqmQbmgsd95dfB6X0I0pvlp7Cc2msfgmKd2oJRk8E5oegZTYSZsnXMy1WB5pAuwc
         K0qkfP8wu6TuJSfeOaMSeHV/o+UySPfmaHn5A=
Message-ID: <491C6FE6.6000601@gmail.com>
Date: Thu, 13 Nov 2008 20:20:22 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: linux-kernel@vger.kernel.org, jonsmirl@gmail.com, jrm8005@gmail.com
Subject: Re: In-kernel IR remote control support
References: <ApnRmVyojFB@christoph>
In-Reply-To: <ApnRmVyojFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Bartelmus wrote:
> Hi,
> 
> on 12 Nov 08 at 14:39, J.R. Mauro wrote:
> [...]
>> On Wed, Nov 5, 2008 at 3:07 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>>> On Wed, Nov 5, 2008 at 2:59 PM, J.R. Mauro <jrm8...@gmail.com> wrote:
>>>> On Wed, Nov 5, 2008 at 2:47 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>>>>> New release of in-kernel IR support implementing evdev support. The goal
>>>>> of in-kernel IR is to integrate IR events into the evdev input event
>>>>> queue and maintain ordering of events from all input devices. Still
>>>>> looking for help with this project.
> 
>>>> (Forgive me if this has already been asked or dealt with)
> 
>>>> Have you contacted the LIRC developers? Is there any overlap between
>>>> your projects?
> 
>>> The LIRC people know about this. Pieces of the code are coming from
>>> the LIRC source base and being reworked for kernel inclusion.
> 
>> Great, it's nice to see there's cooperation.
> 
> LOL. There's just a small omission from Jon's side...
> Yes, LIRC people know about this. And Jon has a no-go from me.
> 
> Decoding IR protocols in-kernel is the wrong way IMHO and this will not be  
> supported by LIRC as long as I maintain LIRC.
> It's simply not possible to decode all existing IR protocols and LIRC just  
> stores the timing data for these protocols as-is without trying to decode  
> them. With the in-kernel decoding approach these remotes cannot be  
> supported. I'm not willing to sacrifice the support for these even though  
> they only consist of a very small fraction of remotes in use.
+1 

I agree completely.
This way we can make lirc to recognize any remote.

Don't yet have a general receiver, but when I have one, I would like to use my remotes,
and who knows what protocols they use...


Best solution is to make new input layer message, a raw PCM data.
or, you can even keep the daemon, but make it inject input events back to input system.

The only think I don't like at all about lirc is that you need special library to talk to it
while I want remotes to be used as a keyboards.

Btw, one can write a lirc client that does the above, but this is hackish.

Some standard ir protocols can be decoded in kernel, but there should be standard (not debug) way
to do so in userspace.

Just my .02 cents,

Best regards,
	Maxim Levitsky

> 
> Christoph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

