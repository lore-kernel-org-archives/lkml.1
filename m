Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYKNRiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYKNRiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYKNRiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:38:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:15911 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYKNRiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:38:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VJLiP+jyKiJCBZs/KtaX87kt8euvs413SYUoZnyHqBfmSc4zCpKnXxI5lKxo8j9tG6
         7Ao3gUWyrrzF4c1OTOLDr/HmO9V6kCJ/2wWLbcfX7ybYiLlTGq+2BXNOt00bN3+v44cm
         fxCpBi/aLLuw4m2xU6IOUc8ShL7veSwEmBfbs=
Message-ID: <491DB773.5070708@gmail.com>
Date: Fri, 14 Nov 2008 19:37:55 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Emmanuel Fust <emmanuel.fuste@laposte.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: In-kernel IR remote control support
References: <13134331.2018681226657305244.JavaMail.www@wwinf8303>
In-Reply-To: <13134331.2018681226657305244.JavaMail.www@wwinf8303>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emmanuel Fust wrote:
> Hi,
> 
>  >Christoph Bartelmus wrote:
>  >> Hi,
>  >>
>  >> on 12 Nov 08 at 14:39, J.R. Mauro wrote:
>  >> [...]
>  >>> On Wed, Nov 5, 2008 at 3:07 PM, Jon Smirl wrote:
>  >>>> On Wed, Nov 5, 2008 at 2:59 PM, J.R. Mauro wrote:
>  >>>>> On Wed, Nov 5, 2008 at 2:47 PM, Jon Smirl wrote:
>  >>>>>> New release of in-kernel IR support implementing evdev support. 
> The goal
>  >>>>>> of in-kernel IR is to integrate IR events into the evdev input event
>  >>>>>> queue and maintain ordering of events from all input devices. Still
>  >>>>>> looking for help with this project.
>  >>
>  >>>>> (Forgive me if this has already been asked or dealt with)
>  >>
>  >>>>> Have you contacted the LIRC developers? Is there any overlap between
>  >>>>> your projects?
>  >>
>  >>>> The LIRC people know about this. Pieces of the code are coming from
>  >>>> the LIRC source base and being reworked for kernel inclusion.
>  >>
>  >>> Great, it's nice to see there's cooperation.
>  >>
>  >> LOL. There's just a small omission from Jon's side...
>  >> Yes, LIRC people know about this. And Jon has a no-go from me.
>  >>
>  >> Decoding IR protocols in-kernel is the wrong way IMHO and this will 
> not be
>  >> supported by LIRC as long as I maintain LIRC.
>  >> It's simply not possible to decode all existing IR protocols and 
> LIRC just
>  >> stores the timing data for these protocols as-is without trying to 
> decode
>  >> them. With the in-kernel decoding approach these remotes cannot be
>  >> supported. I'm not willing to sacrifice the support for these even 
> though
>  >> they only consist of a very small fraction of remotes in use.
>  >+1
>  >
>  >I agree completely.
>  >This way we can make lirc to recognize any remote.
>  >
>  >Don't yet have a general receiver, but when I have one, I would like 
> to use my remotes,
>  >and who knows what protocols they use...
>  >
>  >
>  >Best solution is to make new input layer message, a raw PCM data.
> No, raw PCM data has nothing to do as an input layer message. Is is not 
> an input event.
> 
>  >or, you can even keep the daemon, but make it inject input events back 
> to input system.
>  >
> Exactly as Jon designed it. Use the raw sysfs interface to get raw data 
> and inject input events back to input system.
> 
>  >The only think I don't like at all about lirc is that you need special 
> library to talk
>  > to it while I want remotes to be used as a keyboards.
>  >
>  >Btw, one can write a lirc client that does the above, but this is hackish.
>  >
>  >Some standard ir protocols can be decoded in kernel, but there should 
> be standard
>  > (not debug) way to do so in userspace.
> 
> Call it raw instead of debug and you're done. Lircd will be the main if 
> not the only regular user of this raw interface.
I was under impression that sysfs interface isn't fit for everyday use.
Is it at least possible to receive a continuous stream of data?
Then lets rename it to regular not debug interface.


> 
> Jon did a wonderful jobs, it's thin, simple, clean and fit perfectly 
> with the input system. No more specialized libs. With a little work, 
> existing decoders could cover more than 70% the IR remotes. With more 
> engines, we could rapidly cover more than 95% of know IR protocols. A 
> simplified lircd could at any time cover the rest.
Best regards,
	Maxim Levitsky

> 
> Bests regards,
> Emmanuel.
> ---
> 
> 
> 
> /Créez votre adresse <http://www.laposte.net> électronique 
> prenom.nom@laposte.net
> 1 Go d'espace de stockage, anti-spam et anti-virus intégrés./

