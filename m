Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYCKSPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYCKSPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYCKSPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:15:04 -0400
Received: from 182-233-dsl.kielnet.net ([89.27.233.182]:40302 "EHLO
	einstein.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751012AbYCKSPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:15:03 -0400
Message-ID: <47D6CC23.5020202@aol.com>
Date: Tue, 11 Mar 2008 19:14:59 +0100
From: Oliver Schuster <olivers137@aol.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080213)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] v2.5.25-rc patches
References: <20080310201419.GA7623@infomag.infomag.iguana.be>
In-Reply-To: <20080310201419.GA7623@infomag.infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

WARNING

this patch can cause serious problems in the case, that someone use it 
with an it8712 rev. 8 and above.

Wim Van Sebroeck wrote:
> Hi Linus,
> 
> Please pull from 'master' branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> or if master.kernel.org hasn't synced up yet:
> 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> 
> This will update the following files: 
>  ....

Your patch changes it8712f_wdt.c in function t8712f_wdt_update_margin():

> -	superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
> +	if (revision >= 0x08)
> +		superio_outw(units, WDT_TIMEOUT);
> +	else
> +		superio_outb(units, WDT_TIMEOUT);

but here you can't use superio_outw, because the bytes are swapped 
--historical reason.

I suggest to substitute
	superio_outw(units, WDT_TIMEOUT);
with
	superio_outb(units >> 8, WDT_TIMEOUT + 1);
	superio_outb(units, WDT_TIMEOUT);

or to change the patch with (only the referenced position above)

+	if (revision >= 0x08)
+		superio_outb(units >> 8, WDT_TIMEOUT + 1);
+
+	superio_outb(units, WDT_TIMEOUT);

I'm sorry, that I resend this message.
Now I'm able to respond correctly to existing thread.

Regards,
Oliver
