Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYBYSOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYBYSOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYBYSN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:13:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYBYSN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:13:57 -0500
Message-ID: <47C3053D.5060504@zytor.com>
Date: Mon, 25 Feb 2008 10:13:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
In-Reply-To: <20080225180750.GA31054@mailshack.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
>  arch/x86/kernel/head64.c |   45 +++++++++++++++++++++++++++------------------
>  1 files changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 38f32e7..b684552 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -49,33 +49,42 @@ static void __init copy_bootdata(char *real_mode_data)
>  	}
>  }
>  
> -#define EBDA_ADDR_POINTER 0x40E
> +#define BIOS_EBDA_SEGMENT 0x40E
> +#define BIOS_LOWMEM_KILOBYTES 0x413
>  

Linus has specific comments in the 32-bit code that states we do not 
want to use address 0x413 for anything - if nothing else because it's 
often lowered when there is boottime code involved like CD-ROM booting 
or PXE.

Either way, the code should be shared between 32 and 64 bits.  There is 
nothing bitsize-specific about it!

	-hpa
