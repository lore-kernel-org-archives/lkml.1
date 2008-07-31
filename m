Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYGaUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYGaUNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYGaUNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:13:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYGaUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:13:35 -0400
Date: Thu, 31 Jul 2008 13:10:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, bzolnier@gmail.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-Id: <20080731131056.eecc4826.akpm@linux-foundation.org>
In-Reply-To: <20080731194207.GA12233@anvil.corenet.prv>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au>
	<20080731104437.5e5669bc.akpm@linux-foundation.org>
	<20080731141302.ZZRA012@mailhub.coreip.homeip.net>
	<200807312048.57575.rjw@sisk.pl>
	<20080731145023.ZZRA012@mailhub.coreip.homeip.net>
	<alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org>
	<20080731151625.ZZRA012@mailhub.coreip.homeip.net>
	<20080731194207.GA12233@anvil.corenet.prv>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 15:42:07 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> -				return bits_to_user(bits, len, _IOC_SIZE(cmd), p, compat_mode);
> +
> +				if ((_IOC_NR(cmd) & EV_MAX) == EV_KEY && buf_len == 0x1ff) {
> +					printk(KERN_WARNING
> +						"evdev.c(EVIOCGBIT): Detected suspicious "
> +						"buffer size 0x1ff, limiting output to 64 "
> +						"bytes. Make sure you are not using "
> +						"EVIOCGBIT(EV_KEY, KEY_MAX)\n");
> +					buf_len = 64; 
> +				}

If that works then great.  But I think the printk could be improved. 
Please provide sufficient information so that users (not programmers)
can go off and fix things up without needing to email kernel developers.

One suitable approach would be

	printk("see http://userweb.kernel.org/~dtor/read-this.txt")

