Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbZBYVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbZBYVBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZBYVBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:01:06 -0500
Received: from omr4.networksolutionsemail.com ([205.178.146.54]:47275 "EHLO
	omr4.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756330AbZBYVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:01:05 -0500
Message-ID: <49A5B17C.9060705@nerdgrounds.com>
Date: Wed, 25 Feb 2009 13:00:44 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: ATI Radeon DIRECTCOLOR -> TRUECOLOR patch
References: <49A52A73.2000406@nerdgrounds.com>	 <20090225.035712.103590506.davem@davemloft.net> <1235594524.8805.326.camel@pasglop>
In-Reply-To: <1235594524.8805.326.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  But at the very least could radeonfb default to truecolor-like 
behavior and leave the bizarre ramp mapping for programs that want it?
> On Wed, 2009-02-25 at 03:57 -0800, David Miller wrote:
>> From: Jonathan Campbell <jon@nerdgrounds.com>
>> Date: Wed, 25 Feb 2009 03:24:35 -0800
>>
>> [ Ben H. is the Radeon driver maintainer, as listed in
>>   linux/MAINTAINERS, you might want to CC: him ]
>>
>>> I don't know about you but when I ask the framebuffer to set up
>>> 16-bit or 32-bit RGB modes I expect a video mode to be set up with
>>> R, G, and B mapped linearly so that I can display images properly,
>>> not some odd "directcolor" mode that seems to serve no other purpose
>>> than to avoid a few shifts converting the fbcon palette to an RGB
>>> triplet.
>> It might be using DIRECTCOLOR for compatibility with openfirmware,
>> BOOTX, or similar on PowerPC.
>
> Hrm, the kernel fb layer does seem to do strange things with the palette
> for >8bpp stuff indeed. I'm not entirely sure why.
>
> The problem if you switch to truecolor is that you remove the ability to
> set the gamma ramp completely which some apps use.
>
> Normally, I'd say it's the responsibility of your application, when it's
> displaying pictures, to set an appropriate cmap. If you don't like the
> one set by fbcon for displaying text, just set another one. Ie. You
> aren't -supposed- to mix graphics and fbcon text from an application...
> if you're going to blast to the fb, you should switch to KD_GRAPHICS (ie
> take ownership of the VT) and set a linear ramp yourself.
>
> Cheers,
> Ben.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

