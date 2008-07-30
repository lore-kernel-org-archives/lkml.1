Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYG3QtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYG3QtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYG3Qsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:48:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbYG3Qsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:48:54 -0400
Date: Wed, 30 Jul 2008 09:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, xsonnek@gmail.com,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] semaphore: declare down_try
Message-Id: <20080730094817.135cdbfa.akpm@linux-foundation.org>
In-Reply-To: <48905028.5060908@gmail.com>
References: <1217417115-28574-1-git-send-email-jirislaby@gmail.com>
	<48905028.5060908@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 13:27:36 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> Jiri Slaby napsal(a):
> > Maybe you already fixed this, in todays mmotm there is a fix of duplicate
> > down_try definiton, but this problem still persist.
> 
> BTW. there is still bunch of down_trylock(); users, are you about to 
> eliminate them?
> 
>     2    182  /home/latest/xxx/drivers/watchdog/ar7_wdt.c <<ar7_wdt_open>>
>               if (down_trylock(&open_semaphore))
>     3    309  /home/latest/xxx/drivers/watchdog/it8712f_wdt.c
>               <<it8712f_wdt_open>>
>               if (down_trylock(&it8712f_wdt_sem))
>     4    214  /home/latest/xxx/drivers/watchdog/s3c2410_wdt.c
>               <<s3c2410wdt_open>>
>               if(down_trylock(&open_lock))
>     5    154  /home/latest/xxx/drivers/watchdog/sc1200wdt.c <<sc1200wdt_open>>
>               if (down_trylock(&open_sem))
>     6     95  /home/latest/xxx/drivers/watchdog/scx200_wdt.c <<scx200_wdt_open>>
>               if (down_trylock(&open_semaphore))
>     7    429  /home/latest/xxx/drivers/watchdog/wdt_pci.c <<wdtpci_open>>
>               if (down_trylock(&open_sem))

oh crap, yes, sorry, I had a bit of a catastrophe with two different
versions of the sameish thing coming from two directions and my
approach to fixing that was to drop one patch and to await the next
linux-next pull for the other.  Forgot.
