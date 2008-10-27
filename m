Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYJ0Npl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYJ0Npl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYJ0Npd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:45:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:25955 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJ0Npc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HSOwGhpaFKCLCWU4IQ/pZ6II1CO2XvLAyAB2oh3f3hBhOhDjlnG8Ku1NmPwIEUdd0Z
         7NnWWS6FXdZo/hdupIrLel/MB3wMebjoe5t06nEfgV78t9eqsr9dC9/hHCondwQRARBL
         eQbUBW3bEH75pZQL4MnvOM7xJ22OtmG4xVH3A=
Message-ID: <3aaafc130810270645m370a9f15ib1c5804348b6a7ed@mail.gmail.com>
Date: Mon, 27 Oct 2008 09:45:32 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: staging: me4000: remove duplicated #include's
Cc: "Greg KH" <greg@kroah.com>, "Huang Weiyi" <weiyi.huang@gmail.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20081026220539.GC1586@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081018113833.61B4.WEIYI.HUANG@gmail.com>
	 <20081020211822.GA30320@kroah.com>
	 <20081026213335.GB1586@cs181140183.pp.htv.fi>
	 <3aaafc130810261440q1f801a3bv8b74d5629aa1edfc@mail.gmail.com>
	 <20081026220539.GC1586@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 6:05 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Sun, Oct 26, 2008 at 05:40:04PM -0400, J.R. Mauro wrote:
>> On Sun, Oct 26, 2008 at 5:33 PM, Adrian Bunk <bunk@kernel.org> wrote:
>> > On Mon, Oct 20, 2008 at 02:18:22PM -0700, Greg KH wrote:
>> >> On Sat, Oct 18, 2008 at 11:52:15AM +0800, Huang Weiyi wrote:
>> >> > Removed duplicated #include's in drivers/staging/me4000/me4000.c
>> >> >    asm/uaccess.h
>> >> >    linux/fs.h
>> >> >
>> >> > Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
>> >> >
>> >> > diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
>> >> > index 862dd7f..90de6f0 100644
>> >> > --- a/drivers/staging/me4000/me4000.c
>> >> > +++ b/drivers/staging/me4000/me4000.c
>> >> > @@ -30,7 +30,6 @@
>> >> >  #include <asm/uaccess.h>
>> >> >  #include <linux/errno.h>
>> >> >  #include <linux/delay.h>
>> >> > -#include <linux/fs.h>
>> >> >  #include <linux/mm.h>
>> >> >  #include <linux/unistd.h>
>> >> >  #include <linux/list.h>
>> >> > @@ -39,7 +38,6 @@
>> >> >  #include <linux/poll.h>
>> >> >  #include <linux/vmalloc.h>
>> >> >  #include <asm/pgtable.h>
>> >> > -#include <asm/uaccess.h>
>> >> >  #include <linux/types.h>
>> >> >
>> >> >  #include <linux/slab.h>
>> >>
>> >> Hm, this doesn't apply anymore as some cleanups went in that should have
>> >> just made this not needed.
>> >>
>> >> But if you have a script I can run somewhere to verify it, I'd
>> >> appreciate it.
>> >
>> > linux-2.6$ make help | grep include
>> >  includecheck    - Check for duplicate included header files
>> > linux-2.6$
>>
>> Is there a way to get this to just check in a user-specified
>> directory? I didn't see any options for that and adding
>> M=drivers/staging didn't help.
>
> Pipe the output through grep.
>
> Or if you really want to limit what gets checked, setting the path in
> the Makefile is trivial.

Yes, I guess I meant something like this quick-n-dirty patch. I got
bored waiting for the includecheck to finish on the whole source tree,
so it's nice to be able to tell it to check only what I'm interested
in.

(don't try to apply this patch as gmail mutilates tabs)
---

diff --git a/Makefile b/Makefile
index e9c5d47..9b7891c 100644
--- a/Makefile
+++ b/Makefile
@@ -1524,7 +1524,7 @@ tags: FORCE
 # ---------------------------------------------------------------------------

 includecheck:
-       find * $(RCS_FIND_IGNORE) \
+       find $(if $(M),$(M)/)* $(RCS_FIND_IGNORE) \
                -name '*.[hcS]' -type f -print | sort \
                | xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl



>
> cu
> Adrian
>
> --
>
>       "Is there not promise of rain?" Ling Tan asked suddenly out
>        of the darkness. There had been need of rain for many days.
>       "Only a promise," Lao Er said.
>                                       Pearl S. Buck - Dragon Seed
>
>
