Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXKDQfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXKDQfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 11:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXKDQfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 11:35:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48366 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752275AbXKDQfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 11:35:04 -0500
Date: Sun, 4 Nov 2007 17:34:39 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Giacomo Catenazzi <cate@cateee.net>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, sam@ravnborg.org,
       thomas@archlinux.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071104163439.GM12045@stusta.de>
References: <20071103121149.GA22149@uranus.ravnborg.org> <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu> <20071104.023133.241080055.davem@davemloft.net> <20071104152930.GL12045@stusta.de> <472DF121.8000509@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <472DF121.8000509@cateee.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 05:19:45PM +0100, Giacomo Catenazzi wrote:
> Adrian Bunk wrote:
>> On Sun, Nov 04, 2007 at 02:31:33AM -0800, David Miller wrote:
>>> From: Ingo Molnar <mingo@elte.hu>
>>> Date: Sun, 4 Nov 2007 11:04:29 +0100
>>>
>>>> * Adrian Bunk <bunk@kernel.org> wrote:
>>>>
>>>>> I also have CFLAGS set on some computers in my environments since for 
>>>>> packages using GNU autoconf that's the correct way to set the compiler 
>>>>> flags.
>>>>>
>>>>> The kernel already sets all flags correctly, and a user wanting to 
>>>>> change the flags for the kernel is an exception with very special needs 
>>>>> (I'd even claim so special that he could simply edit the Makefile...).
>>>  ...
>>>> At minimum the extra CFLAGS needs to be put into the .config - but 
>>>> that's not a too nice solution either. How about just adding an 
>>>> extra-CFLAGS option to .config and perhaps a 'make configpickupCFLAGS' 
>>>> pass for anyone who wants to propagate the environment CFLAGS into the 
>>>> kernel build.
>>> I totally disagree.
>>>
>>> People can't have it both ways.  CFLAGS has global meaning in every
>>> Makefile based build tree, it's not an "autoconf" thing.  This is well
>>> established practice, and I think it's a good thing the kernel does it
>>> now too.
>> Makefiles do normally not pick such variables from the environment.
>
> ????
>
> Are you sure???
>
> From http://www.gnu.org/software/make/manual/make.html#Environment
>
> : Variables in make can come from the environment in which make
> : is run. Every environment variable that make sees when it starts
> : up is transformed into a make variable with the same name and
> : value.
>
> and most important:
>
> : Thus, by setting the variable CFLAGS in your environment, you
> : can cause all C compilations in most makefiles to use the
> : compiler switches you prefer. This is safe for variables with
> : standard or conventional meanings because you know that no
> : makefile will use them for other things. (Note this is not
> : totally reliable; some makefiles set CFLAGS explicitly and
> : therefore are not affected by the value in the environment.)


Thanks for the correction, I had forgotten about the case where a 
Makefile does not set CFLAGS at all.

But the main point that stuff like e.g. -I/usr/local/dist/include that 
might in some environments be correct for all and required for most 
userspace software should not leak into the kernel still stands.


> ciao
> 	cate

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

