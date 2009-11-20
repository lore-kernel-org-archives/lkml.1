Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZKTVUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZKTVUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZKTVUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:20:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123AbZKTVUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:20:12 -0500
Date: Fri, 20 Nov 2009 13:19:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Fix braille keyboard keysym generation
Message-Id: <20091120131954.0e61c0b6.akpm@linux-foundation.org>
In-Reply-To: <20091117135111.GA14470@const.bordeaux.inria.fr>
References: <20091117135111.GA14470@const.bordeaux.inria.fr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 14:51:11 +0100
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Keysyms stored in key_map[] are not simply K() values, but U(K())
> values, as can be seen in the KDSKBENT ioctl handler.  The
> kernel-generated braille keysyms thus need a U() call too.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
> index 737be95..82c493e 100644
> --- a/drivers/char/keyboard.c
> +++ b/drivers/char/keyboard.c
> @@ -1249,7 +1249,7 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
>  
>  	if (keycode >= NR_KEYS)
>  		if (keycode >= KEY_BRL_DOT1 && keycode <= KEY_BRL_DOT8)
> -			keysym = K(KT_BRL, keycode - KEY_BRL_DOT1 + 1);
> +			keysym = U(K(KT_BRL, keycode - KEY_BRL_DOT1 + 1));
>  		else
>  			return;
>  	else

Sorry, but I cannot work out (with a reasonable amount of effort) what
the user-visible effects of this bug are likely to be.  So I am not in
a position to decide which kernel(s) this patch should be merged into.

Please be careful to include this aspect in the changelog when
appropriate, thanks.

