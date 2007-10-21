Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXJUV1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXJUV1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXJUV1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:27:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXJUV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:27:30 -0400
Message-ID: <471BC416.4090705@zytor.com>
Date: Sun, 21 Oct 2007 14:26:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <471AD5AD.9030000@zytor.com> <471B2918.5090502@googlemail.com> <471B487C.5080209@googlemail.com> <471BA564.3040305@zytor.com> <20071021200214.GA6250@uranus.ravnborg.org> <471BC326.50400@googlemail.com>
In-Reply-To: <471BC326.50400@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
>>
>> Add a #include <linux/types.h> to the-linux-kernel.h and let us know if it helps.
> 
> Does not help , now I get on top the other errors :
> 
> /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/include/iprt/types.h:121: error: redefinition of typedef 'bool'
> /lib/modules/2.6.23-gcfa76f02/build/include/linux/types.h:33: error: previous declaration of 'bool' was here
> 
> ...
> 
> /*
>  * C doesn't have bool.
>  */
> #ifndef __cplusplus
> # if defined(__GNUC__)
> #  if defined(RT_OS_LINUX) && __GNUC__ < 3
> typedef uint8_t bool;
> #  else
> #   if defined(RT_OS_DARWIN) && defined(_STDBOOL_H)
> #    undef bool
> #   endif
> typedef _Bool bool; <- line 121
> #  endif
> # else
> typedef unsigned char bool;
> # endif
> # ifndef true
> #  define true  (1)
> # endif
> # ifndef false
> #  define false (0)
> # endif
> #endif
> 
> 
> Looking at include/iprt/types.h that has already #include <linux/types.h>.
> 

Yeah, this is a VirtualBox problem.

At this point, this is clearly a matter for innotek, not for the 
mainstream kernel development community.

	-hpa
