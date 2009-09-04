Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZIDTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZIDTgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933729AbZIDTgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:36:10 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33278 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbZIDTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:36:08 -0400
X-IronPort-AV: E=Sophos;i="4.44,334,1249272000"; 
   d="scan'208";a="3936255"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: asm-generic update candidates?
Date: Fri, 4 Sep 2009 15:39:28 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200909031729.52538.rgetz@blackfin.uclinux.org> <200909041532.50456.arnd@arndb.de>
In-Reply-To: <200909041532.50456.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200909041539.28384.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 Sep 2009 19:35:22.0072 (UTC) FILETIME=[D7B3F580:01CA2D96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 4 Sep 2009 09:32, Arnd Bergmann pondered:
> On Thursday 03 September 2009, Robin Getz wrote:
> > Arnd:
> > 
> > I was reviewing some files in ./arch/blackfin/include for missing 
copyrights, 
> > and while tracking things down I noticed there were still some likely 
> > candidates for inclusion in asm-generic...
> 
> Ah, thanks. I basically started out with the list of files that exist in
> almost all architectures. I never looked at files that are identical in
> some architectures but nonexistent in more than a few others.
> 
> Also, my plan is to do one architecture at a time,

Which arch are you starting with?

> not one file at a time 
> across all architectures, because that will reduce the need for coordination
> between multiple maintainers.

Makes sense. I guess I saw your earlier commits changing all archs, and 
thought you were doing it the other way around.

> > All seem to be the same file:
> > 
> > md5sum:
> > 5b6b31d728ed2ed0df73c56676fdc68f  blackfin/include/asm/fb.h
> > 5b6b31d728ed2ed0df73c56676fdc68f  cris/include/asm/fb.h
> > 5b6b31d728ed2ed0df73c56676fdc68f  frv/include/asm/fb.h
> > 5b6b31d728ed2ed0df73c56676fdc68f  h8300/include/asm/fb.h
> > 5b6b31d728ed2ed0df73c56676fdc68f  s390/include/asm/fb.h
> > 5b6b31d728ed2ed0df73c56676fdc68f  xtensa/include/asm/fb.h
> 
> Look at the latest version. Some architectures have already started
> using the generic version, e.g. blackfin.

Yeah, sorry - I was looking at our release tree - not Linus's.

> > e31d052cbba4f417ba2158a41b0d8709  arm/include/asm/fb.h
> > e31d052cbba4f417ba2158a41b0d8709  m32r/include/asm/fb.h
> > e31d052cbba4f417ba2158a41b0d8709  sh/include/asm/fb.h
> 
> Interesting one. The only difference between these and the
> above is the use of pgprot_writecombine, which is defined as
> pgprot_noncached on the other architectures.
>  
[snip]
>  
> > There seems to be lots of similarities in
[snip]

Hmm - all I listed are already in Linus's tree...

Sorry about the noise.

> > Do you keep a list somewhere?
> 
> Well, this is how I started out writing doing the common files
> in the first place. I looked at the most similar files, and then
> used vimdiff on up to four files at a time, changing them to
> be exactly identical by editing out all the bitrot.
> 
> In general, if a file exists in asm-generic, it should be usable
> by some of the architectures, if it does not exist then either it
> is too hard to make a generic version or I have not looked at it
> yet.

OK -- here are some identical ones:

8253pit.h (alpha and power)
fbio.h    (m68k and sparc)
md.h      (h8300, alpha and m68k)

I also noticed in Linus's latest (last commit 
37d0892c5a94e208cf863e3b7bac014edee4346d):

cat arch/microblaze/include/asm/ipc.h
#include <asm-generic/ipc.h>

but: ls include/asm-generic/ipc.h
ls: cannot access include/asm-generic/ipc.h: No such file or directory

?

> If you want to help convert an architecture, try doing
> 
> for i in include/asm-generic/*.h ; do
>       vimdiff ${i} arch/${ARCH}/include/asm/${i##*/}
> done
> 
> If the files are identical, replace the contents of the arch
> specific one with a simple #include <asm-generic/${i}>. If they
> are almost identical, add overrides like in
> arch/microblaze/include/asm/posix_types.h, possibly adding the
> option for overriding to the generic file. For files that
> are rather different, just leave them alone.

Will do.

Thanks.
-Robin
