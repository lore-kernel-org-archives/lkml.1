Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYCJWzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYCJWzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYCJWzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:55:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43425 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYCJWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:55:43 -0400
Date: Mon, 10 Mar 2008 23:56:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, devzero@web.de,
       linux-kernel@vger.kernel.org, rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080310225618.GA31624@elf.ucw.cz>
References: <182234194@web.de> <200803101523.03620.dl9pf@gmx.de> <47D56DD3.8060108@zytor.com> <200803101959.47202.dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803101959.47202.dl9pf@gmx.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> What about ...

Thanks for doing this.

> diff --git a/Documentation/kernel-parameters.txt 
> b/Documentation/kernel-parameters.txt
> index 533e67f..19343e1 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1131,6 +1131,10 @@ and is between 256 and 4096 characters. It is defined 
> in the file
>         memmap=nn[KMG]$ss[KMG]
>                         [KNL,ACPI] Mark specific memory as reserved.
>                         Region of memory to be used, from ss to ss+nn.
> +                       Example: Exclude memory from 0x18690000-0x1869ffff
> +                                memmap=0x18690000$64K
> +                                or
> +                                memmap=0x18690000$10000

missing 0x after $.


> diff --git a/Documentation/bad-memory.txt b/Documentation/bad-memory.txt
> new file mode 100644
> index 0000000..53e817d
> --- /dev/null
> +++ b/Documentation/bad-memory.txt
> @@ -0,0 +1,55 @@
> +March 2007
> +Jan-Simon Moeller, dl9pf@gmx.de
> +
> +
> +How to deal with bad memory e.g. reported by memtest86+ ?
> +#########################################################
> +
> +There are three possibilities I know of:
> +
> +1) Buy new memory (best!)
> +
> +2) Try to exchange the memory if you have spare-parts
> +
> +3) Use BadRAM or memmap
> +
> +This Howto is about number 3) .
> +
> +
> +BadRAM
> +######
> +BadRAM is actively developed and available as kernel-patch
> +here:  http://rick.vanrein.org/linux/badram/
> +
> +It takes the patterns of memtest86+ as arguments to exclude the defective
> +areas of the memory.
> +
> +Example: memtest86+ reported here errors at address 0x18691458, 0x18698424 
> and
> +         some others. All had 0x1869xxxx in common, so I chose a pattern of
> +         0x18690000,0xffff0000.
> +         This means exclusion of the area from 0x18690000 to 0x1869ffff
> +         (which is a block of 64k).
> +         My kernel-cmdline was:  badram=0x18690000,0xffff0000
> +
> +There are efforts to bring BadRAM into mainline in some way, possibly using
> +memmap internally (maybe for 2.6.26 ?).
> +Thread on lkml: http://lkml.org/lkml/2008/3/2/42
> +
> +For more details see the BadRAM documentation.
> +
> +
> +memmap
> +######
> +memmap is already in the kernel and usable as kernel-parameter at boot-time.
> +Its syntax is different and you may need to calculate the values by yourself!
> +
> +Syntax to exclude a memory area (see kernel-parameters for details):
> +memmap=<address>$<size>
> +
> +With the numbers of the example above:
> +memmap=0x18690000$64K
> + or
> +memmap=0x18690000$0x10000
> +
> +TODO: Multiple areas to exclude using memmap ?
> +
> 
> Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>

Actually, I'd include both..  I guess you should fix the 0x, the year,
and submit it to akpm (or trivial?).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
