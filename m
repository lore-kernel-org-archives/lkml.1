Return-Path: <linux-kernel-owner+w=401wt.eu-S1764283AbXFKI5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764283AbXFKI5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbXFKI5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:57:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbXFKI5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:57:22 -0400
Date: Mon, 11 Jun 2007 10:56:52 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christian Leber <christian@leber.de>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070611085652.GA4032@suse.de>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070609130817.GI27793@elf.ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha4plus, Kernel 2.6.22-rc3-git2-5-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 03:08:17PM +0200, Pavel Machek wrote:

How about (WARNING! I never have written i386 assembly, my last assembly
experience was 20 years ago on Z80, so this is basically just copy'n paste,
but i hope you get the idea):

> --- a/arch/i386/kernel/acpi/wakeup.S
> +++ b/arch/i386/kernel/acpi/wakeup.S

> @@ -20,6 +35,9 @@ wakeup_code:
>  	wakeup_code_start = .
>  	.code16
>  
> +# Uncomment this to make your computer start producing ugly noise as soon
> +# as BIOS returns to this real-mode entry point.

        testl   $4, video_flags - wakeup_code
        jz      1f
> +	BEEP
   1:
>   	movw	$0xb800, %ax
>  	movw	%ax,%fs
>  	movw	$0x0e00 + 'L', %fs:(0x10)

IIUC, then this should make "echo 4 > /proc/sys/kernel/acpi_video_flags"
enable the beep at run-time.

Yes, i know, it is not a video flag. And not ACPI. Just add another
sysctl if you care.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
