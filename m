Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbYDBHOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbYDBHOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbYDBHOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:14:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53215
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760396AbYDBHOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:14:32 -0400
Date: Wed, 02 Apr 2008 00:14:32 -0700 (PDT)
Message-Id: <20080402.001432.159603826.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, david-b@pacbell.net,
       dbrownell@users.sourceforge.net
Subject: Re: + sparc32-delete-bogus-js-rtc-records.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803312351.m2VNpc2p032266@imap1.linux-foundation.org>
References: <200803312351.m2VNpc2p032266@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2008 16:51:38 -0700

> Subject: sparc32: delete bogus js-rtc records
> From: David Brownell <david-b@pacbell.net>
> 
> While looking at the legacy RTC drivers in the drivers/char directory, I
> noticed what looks like bogus entry for SPARC32 systems: JS_RTC, which seems
> to rely on a non-existent js-rtc file.  Just delete it.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

It is actually used.  Look at what the Makefile is doing:

> diff -puN drivers/char/Makefile~sparc32-delete-bogus-js-rtc-records drivers/char/Makefile
> --- a/drivers/char/Makefile~sparc32-delete-bogus-js-rtc-records
> +++ a/drivers/char/Makefile
> @@ -109,9 +109,6 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
>  
>  obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>  
> -obj-$(CONFIG_JS_RTC)		+= js-rtc.o
> -js-rtc-y = rtc.o
> -
>  # Files generated that shall be removed upon make clean
>  clean-files := consolemap_deftbl.c defkeymap.c

It's building rtc.c into js-rtc.o, and if CONFIG_JS_RTC is set that
gets linked into the kernel.

Andrew, please drop this one.

Thanks.
