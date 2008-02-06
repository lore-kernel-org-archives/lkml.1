Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYBFVHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYBFVHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbYBFVHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:07:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49735 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbYBFVHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:07:03 -0500
Message-ID: <47AA2148.3010408@zytor.com>
Date: Wed, 06 Feb 2008 13:06:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCHv2 2/3] x86: add a crc32 checksum to the kernel image.
References: <1202331640-15610-1-git-send-email-ijc@hellion.org.uk> <1202331640-15610-2-git-send-email-ijc@hellion.org.uk> <1202331640-15610-3-git-send-email-ijc@hellion.org.uk>
In-Reply-To: <1202331640-15610-3-git-send-email-ijc@hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  Documentation/i386/boot.txt |    7 +++
>  arch/x86/boot/tools/build.c |   88 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 94 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
> index b5f5ba1..b567fb5 100644
> --- a/Documentation/i386/boot.txt
> +++ b/Documentation/i386/boot.txt
> @@ -531,6 +531,13 @@ Protocol:	2.08+
>  
>    The length of the compressed payload.
>  
> +**** THE IMAGE CHECKSUM
> +
> +The CRC-32 is calculated over the entire file using an initial
> +remainder of 0xffffffff.  The checksum is appended to the file;
> +therefore the CRC of the file up to the limit specified in the syssize
> +field of the header is always 0.
> +


This doesn't specify that the image checksum is present only for boot 
protocol 2.08 or later, nor does it specify the characteristic 
polynomial (for CRC32 in particular, I realize the Autodin II polynomial 
is pretty close to universal, but it should at least state that it is used.)

>  **** THE KERNEL COMMAND LINE
>  
>  The kernel command line has become an important way for the boot
> diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
> index b424874..2ba22e8 100644
> --- a/arch/x86/boot/tools/build.c
> +++ b/arch/x86/boot/tools/build.c
> @@ -50,6 +50,75 @@ typedef unsigned long  u32;
>  u8 buf[SETUP_SECT_MAX*512];
>  int is_big_kernel;
>  
> +/*----------------------------------------------------------------------*/
> +
> +static const unsigned int crctab32[] = {

Really should be "u32" rather than "unsigned int".

> +	0x00000000U, 0x77073096U, 0xee0e612cU, 0x990951baU, 0x076dc419U,

The "U"s are redundant.

	-hpa
