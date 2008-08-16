Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYHPGej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYHPGej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 02:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYHPGeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 02:34:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48191 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYHPGeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 02:34:31 -0400
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc3 21/28] mdb: disable console warnings if the debugger is present.
From: Andi Kleen <andi@firstfloor.org>
References: <200808160341.m7G3flG1022571@wolfmountaingroup.com>
Date: Sat, 16 Aug 2008 08:34:28 +0200
In-Reply-To: <200808160341.m7G3flG1022571@wolfmountaingroup.com> (jmerkey@wolfmountaingroup.com's message of "Fri, 15 Aug 2008 21:41:47 -0600")
Message-ID: <87ljyxxybv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com writes:
>  
>  /* Some debug stub to catch some of the obvious races in the VT code */
> +
> +#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
> +#define WARN_CONSOLE_UNLOCKED()
> +#else
>  #if 1
>  #define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() && !oops_in_progress)
>  #else
>  #define WARN_CONSOLE_UNLOCKED()
>  #endif
> +#endif /* CONFIG_MDB */

The obvious alternative would be to just set oops_in_progress
while the debugger runs.

-Andi
