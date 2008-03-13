Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYCMKpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYCMKpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYCMKpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:45:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:54330 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751044AbYCMKpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:45:31 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX19Xu3w2sZdXpw463d4jq0p15wLcmwA/L5v/aPWtOV
	2GMpkbkH8hr2bj
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: document memmap option better and help people with bad memory
Date: Thu, 13 Mar 2008 11:45:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
References: <20080313080804.GA19808@elf.ucw.cz>
In-Reply-To: <20080313080804.GA19808@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803131145.28550.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nack ... See comments ..


Am Donnerstag, 13. März 2008 09:08:04 schrieb Pavel Machek:
> Provide example for memmap exclude option (it is slightly strange an
> non-trivial) and provide nice small HOWTO for people with bad memory.
>
> Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
> ---
> commit ec630f2291d7a3a154e22fa54cd74e5f6aa47f9a
> tree 9cf33f9fcda3ea363061acebc971c37815f6c907
> parent 456fc99ea933d38466ee25681908868cde3425c5
> author Pavel <pavel@amd.ucw.cz> Thu, 13 Mar 2008 09:06:15 +0100
> committer Pavel <pavel@amd.ucw.cz> Thu, 13 Mar 2008 09:06:15 +0100
>
>  Documentation/bad_memory.txt        |   45
> +++++++++++++++++++++++++++++++++++ Documentation/kernel-parameters.txt |  
>  4 +++
>  2 files changed, 49 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/bad_memory.txt b/Documentation/bad_memory.txt
> new file mode 100644
> index 0000000..df84162
> --- /dev/null
> +++ b/Documentation/bad_memory.txt
> @@ -0,0 +1,45 @@
> +March 2008
> +Jan-Simon Moeller, dl9pf@gmx.de
> +
> +
> +How to deal with bad memory e.g. reported by memtest86+ ?
> +#########################################################
> +
> +There are three possibilities I know of:
> +
> +1) Reinsert/swap the memory modules
> +
> +2) Buy new modules (best!) or try to exchange the memory
> +   if you have spare-parts
> +
> +3) Use BadRAM or memmap
> +
> +This Howto is about number 3) .
> +
> +
> +BadRAM
> +######
> +BadRAM is the actively developed and available as kernel-patch
Typo from me: ^^^ remove "the"
> +here:  http://rick.vanrein.org/linux/badram/
> +
> +For more details see the BadRAM documentation.
Example: memtest86+ <- was here ... and has its context here (BadRAM-Pattern 
and so on) ...
Just switch the place.

> +
> +memmap
> +######
> +
> +memmap is already in the kernel and usable as kernel-parameter at
> +boot-time.  Its syntax is slightly strange and you may need to
> +calculate the values by yourself!
> +
> +Syntax to exclude a memory area (see kernel-parameters.txt for details):
> +memmap=<size>$<address>
> +
<move to BadRAM section>
> +Example: memtest86+ reported here errors at address 0x18691458, 0x18698424
> and +         some others. All had 0x1869xxxx in common, so I chose a
> pattern of +         0x18690000,0xffff0000.
</move>
> +
> +With the numbers of the example above:
> +memmap=64K$0x18690000
> + or
> +memmap=0x10000$0x18690000
> +
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt index 533e67f..f25da88 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1131,6 +1131,10 @@ and is between 256 and 4096 characters.
>  	memmap=nn[KMG]$ss[KMG]
>  			[KNL,ACPI] Mark specific memory as reserved.
>  			Region of memory to be used, from ss to ss+nn.
> +			Example: Exclude memory from 0x18690000-0x1869ffff
> +			         memmap=64K$0x18690000
> +			         or
> +			         memmap=0x10000$0x18690000
>
>  	meye.*=		[HW] Set MotionEye Camera parameters
>  			See Documentation/video4linux/meye.txt.


Tnx, Pavel for inclusion.

Best regards, 
Jan-Simon

