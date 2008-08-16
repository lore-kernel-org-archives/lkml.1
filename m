Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbYHPGbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbYHPGbF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 02:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYHPGa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 02:30:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59025 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYHPGaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 02:30:55 -0400
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc3 19/28] mdb: adding notify_die handler for keyboard debugger entry
From: Andi Kleen <andi@firstfloor.org>
References: <200808160341.m7G3flhk022569@wolfmountaingroup.com>
Date: Sat, 16 Aug 2008 08:30:53 +0200
In-Reply-To: <200808160341.m7G3flhk022569@wolfmountaingroup.com> (jmerkey@wolfmountaingroup.com's message of "Fri, 15 Aug 2008 21:41:47 -0600")
Message-ID: <87pro9xyhu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com writes:
 
> +#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
> +	if (down && !rep && keycode == KEY_PAUSE)
> +        {
> +	   if (notify_die(DIE_KERNELDEBUG, NULL, get_irq_regs(),
> +                          0, -1, SIGINT) == NOTIFY_STOP)
> +	      return;
> +	}
> +#endif
> +
>  #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
>  	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
>  		if (!sysrq_down) {

A nicer alternative to adding an hook here would be to use 
register_sysrq_key() to register a sysrq key that triggers
the debugger.  That function is also already exported.

-Andi
