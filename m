Return-Path: <linux-kernel-owner+w=401wt.eu-S1764146AbYA1XbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764146AbYA1XbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYA1XbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:31:05 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4118 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYA1XbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:31:04 -0500
Subject: Re: [PATCH 6/7] X86:  include missing KERN_ facility level
From: Joe Perches <joe@perches.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080129000803.69b54c7e@paolo-desktop>
References: <20080129000803.69b54c7e@paolo-desktop>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 15:30:35 -0800
Message-Id: <1201563036.23527.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 00:08 +0100, Paolo Ciarrocchi wrote:
> \diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
> index 6102fe0..569a62e 100644
> --- a/arch/x86/math-emu/errors.c
> +++ b/arch/x86/math-emu/errors.c
> @@ -57,65 +57,65 @@ void FPU_printall(void)
>  
>    RE_ENTRANT_CHECK_OFF;
>    /* No need to check access_ok(), we have previously fetched these bytes. */
> -  printk("At %p:", (void *) address);
> +  printk(KERN_ERR "At %p:", (void *) address);
>    if (FPU_CS == __USER_CS) {
>  #define MAX_PRINTED_BYTES 20
>        for (i = 0; i < MAX_PRINTED_BYTES; i++) {
>  	  FPU_get_user(byte1, (u_char __user *) address);
>  	  if ((byte1 & 0xf8) == 0xd8) {
> -	      printk(" %02x", byte1);
> +	      printk(KERN_ERR " %02x", byte1);
>  	      break;
>  	    }
> -	  printk(" [%02x]", byte1);
> +	  printk(KERN_ERR " [%02x]", byte1);
>  	  address++;
>  	}

KERN_ prefixes are used only at the start of a line.
You should probably use print_hex_dump.


