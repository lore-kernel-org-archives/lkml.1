Return-Path: <linux-kernel-owner+w=401wt.eu-S1763361AbYBBOCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763361AbYBBOCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYBBOCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:02:31 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58825 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYBBOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:02:30 -0500
Date: Sat, 2 Feb 2008 15:02:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warning patch - microcode.c
Message-ID: <20080202140233.GA23877@uranus.ravnborg.org>
References: <804dabb00802020039j7ec7b66dlbf05fc9a80e1600a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802020039j7ec7b66dlbf05fc9a80e1600a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 04:39:02PM +0800, Peter Teoh wrote:
> The following errors during compilation is corrected by the following
> patch (against the latest linus tree):
> 
> WARNING: arch/x86/kernel/microcode.o(.exit.text+0x6): Section mismatch
> in reference from the function cleanup_module() to the variable
> .cpuinit.data:mc_cpu_notifier

I have missed this one when I did my last fix to that file.
But your patch is not good.

Annotating the microcode_exit() function with __init will
cause the kernel to drop the code long before we need it.

I will look into this later and post a fix for the warning.

	Sam

> @@ -831,7 +831,7 @@ static int __init microcode_init (void)
>         return 0;
>  }
> 
> -static void __exit microcode_exit (void)
> +static void __init microcode_exit (void)
>  {

