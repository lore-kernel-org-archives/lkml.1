Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXEZFrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXEZFrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXEZFrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:47:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54801
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbXEZFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:47:05 -0400
Date: Fri, 25 May 2007 21:54:20 -0700 (PDT)
Message-Id: <20070525.215420.74747016.davem@davemloft.net>
To: hugh@veritas.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       egmont@uhulinux.hu, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] fix compat console unimap regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705260032250.25650@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0705260032250.25650@blonde.wat.veritas.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>
Date: Sat, 26 May 2007 00:39:17 +0100 (BST)

> Why is it that since the 2f1a2ccb9c0de632ab07193becf5f7121794f6ae console
> UTF-8 fixes went into 2.6.22-rc1, the PowerMac G5 shows only inverse video
> question marks for the text on tty2-6? whereas tty1 is fine, and so is x86.
> 
> No fault of that patch: by removing the old fallback behaviour, it reveals
> that 32-bit setfont running on 64-bit kernels has only really worked on
> the current console, the rest getting faked by that inadequate fallback.
> 
> Bring the compat do_unimap_ioctl into line with the main one: PIO_UNIMAP
> and GIO_UNIMAP apply to the specified tty, not redirected to fg_console.
> Use the same checks, and most particularly, remember to check access_ok:
> con_set_unimap and con_get_unimap are using __get_user and __put_user.
> 
> And the compat vt_check should ask for the same capability as the main
> one, CAP_SYS_TTY_CONFIG rather than CAP_SYS_ADMIN.  Added in vt_ioctl's
> vc_cons_allocated check for safety, though failure may well be impossible.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Thanks for figuring this out, I've been wondering what in the
world was causing this on sparc64.
