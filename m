Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbZCMHFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbZCMHFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZCMHFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:05:03 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:55359 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750761AbZCMHFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:05:02 -0400
Message-ID: <49BA0599.6070206@snapgear.com>
Date: Fri, 13 Mar 2009 17:04:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
References: <200903120437.03837.rob@landley.net> <20090312210216.GB14205@uranus.ravnborg.org> <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com> <200903122225.04560.rob@landley.net>
In-Reply-To: <200903122225.04560.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rob Landley wrote:
> On Thursday 12 March 2009 17:40:02 Geert Uytterhoeven wrote:
>> On Thu, Mar 12, 2009 at 22:02, Sam Ravnborg <sam@ravnborg.org> wrote:
>>>> And, yes, I can confirm the m68k include/asm/unistd.h from linux-next
>>>> actually has contents, thanks to commit
>>>> 646652bded41f4c3bd375b4e03a25b42da93f40b
>>>>
>>>> Anyway, here's hoping the fix makes it into 2.6.29.
>>> Why not telling the m68k maintainer that you think it should go into
>>> 2.6.29?
> 
> I contacted the headers_install maintainer about a headers_install problem, 
> and was pointed to an existing fix upstream.  This seemed to imply awareness 
> of the problem?
> 
> Happy to follow up more, wasn't aware it was required...
> 
>> There are a few more:
>>
>> param.h:#include "param_no.h"
>> param.h:#include "param_mm.h"
>> ptrace.h:#include "ptrace_no.h"
>> ptrace.h:#include "ptrace_mm.h"
>> setup.h:#include "setup_no.h"
>> setup.h:#include "setup_mm.h"
>> sigcontext.h:#include "sigcontext_no.h"
>> sigcontext.h:#include "sigcontext_mm.h"
>> siginfo.h:#include "siginfo_no.h"
>> siginfo.h:#include "siginfo_mm.h"
>> signal.h:#include "signal_no.h"
>> signal.h:#include "signal_mm.h"
>> swab.h:#include "swab_no.h"
>> swab.h:#include "swab_mm.h"
>>
>> Rob, do these also causes problems?
>> Some (not all) of them are fixed in linux-next.
> 
> I'm trying to build uClibc against the new headers.  I just got around to 
> extracting the patch to fix that one file and testing it in my build system, 
> and this time it broke with:
> 
>   build/cross-compiler-m68k/include/asm/param.h:4:22: error: param_mm.h: No
>   such file or directory
> 
> So yeah, it's still unhappy.  Dunno how many of these are still needed to 
> build the cross compiler, and then who knows what other packages need to 
> build.  Presumably all of it.
> 
> Keep in mind I still haven't found an emulator for m68k that actually boots a 
> linux kernel, so my m68k support is purely theoretical.  (I poked at mess and 
> uae a bit today, but they don't do the "qemu -kernel" thing I'm using for the 
> other targets, and qemu itself only seems to support coldfire and not a full-
> blown m68k.)  I'm following up on this because it's a regression.  Under 
> 2.6.28 the m68k target was building a kernel and root filesystem, but I don't 
> have hardware to run it and have never been able to test it, so isn't really 
> very useful for me.  It's really just there so that if qemu grows the rest of 
> m68k support (patches have been submitted but not merged), I'll be ready.
> 
> P.S.  If you're bored and want to try my test build for yourself:
> 
>   wget http://impactlinux.com/hg/firmware/archive/tip.tar.bz2
>   tar xvjf tip.tar.bz2
>   cd firmware-*
>   USE_UNSTABLE=linux ./build.sh m68k
> 
> Without the USE_UNSTABLE=linux it uses 2.6.28 and builds to completion, with 
> it the build uses 2.6.29-rc7 (or whatever URL's listed as the UNSTABLE= value 
> for linux in download.sh) and it breaks trying to add uClibc to the cross 
> compiler.
> 
> But then anything that actually _uses_ the "make headers_install" output to 
> build stuff against should notice pretty quickly whether or not it #includes 
> missing files.

I pretty quick time I can fix up the last couple on the above list.
But do we want to put all that change into 2.6.29-rc at this point?

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
