Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbZEBOQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbZEBOQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZEBOQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:16:41 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37315 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755359AbZEBOQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:16:39 -0400
Date: Sat, 2 May 2009 10:16:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David VomLehn <dvomlehn@cisco.com>
cc: Sergey Vlasov <vsu@altlinux.ru>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       <netdev@vger.kernel.org>, <arjan@infradead.org>
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
 synchronization, v5
In-Reply-To: <20090502133153.GA8116@atlas.home>
Message-ID: <Pine.LNX.4.44L0.0905021010200.23879-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with Sergey's comments.  In addition:

On Fri, May 01, 2009 at 07:25:51PM -0700, David VomLehn wrote:

> +initdev_wait(enum initdev_type type, bool (*done)(void))
> +	Wait until one of two conditions is met:
> +	o	All possible init devices of the given type have been probed
> +	o	The "done" function returns true
> +
> +	The type is one of:
> +		BOOTDEV_CONSOLE
> +		BOOTDEV_NETDEV
> +		BOOTDEV_BLOCK

These should be named INITDEV_CONSOLE_TYPE and so on, with the final 
_TYPE suffix to help prevent confusion with INITDEV_CONSOLE_MASK.

Also, in patch 3/5:

> --- a/drivers/accessibility/braille/braille_console.c
> +++ b/drivers/accessibility/braille/braille_console.c
> @@ -35,6 +35,7 @@
>  #include <linux/keyboard.h>
>  #include <linux/kbd_kern.h>
>  #include <linux/input.h>
> +#include <linux/initdev.h>

What does this do?  It looks like a typo.

Alan Stern

