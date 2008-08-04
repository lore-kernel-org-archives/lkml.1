Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYHDOc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYHDOc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYHDOb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:31:58 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51414 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYHDOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:31:57 -0400
Message-ID: <489712A3.9070804@s5r6.in-berlin.de>
Date: Mon, 04 Aug 2008 16:30:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1 19/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
References: <51989.166.70.238.45.1217831969.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <51989.166.70.238.45.1217831969.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> --- a/drivers/char/keyboard.c	2008-08-03 16:09:56.000000000 -0600
> +++ b/drivers/char/keyboard.c	2008-08-03 16:15:00.000000000 -0600
> @@ -1180,6 +1180,16 @@
>  			if (keycode < BTN_MISC && printk_ratelimit())
>  				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode
> %d\n", keycode);
> 
> +#ifdef CONFIG_MDB
> +	if (down && !rep && keycode == KEY_PAUSE)
> +        {
> +           extern int mdb(int reason, int error, struct pt_regs *regs);
> +
> +	   mdb(19, 0, get_irq_regs());
> +	   return;
> +	}
> +#endif
> +

It's safer to declare extern functions in header files.
-- 
Stefan Richter
-=====-==--- =--- --=--
http://arcgraph.de/sr/
