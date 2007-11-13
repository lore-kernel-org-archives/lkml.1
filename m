Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbXKMFXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbXKMFXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXKMFX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:23:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950AbXKMFX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:23:26 -0500
Date: Mon, 12 Nov 2007 21:23:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3]: tty - fix network driver interactions with
 TCGET/SET calls
Message-Id: <20071112212315.e23dfe7d.akpm@linux-foundation.org>
In-Reply-To: <20071102153329.1a236477@the-village.bc.nu>
References: <20071102153329.1a236477@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007 15:33:29 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Dave Miller noted various cases where line disciplines for things like
> ppp go poking around in termios themselves in ways that broke with the
> new termios code. Rather than have them all learning about termios
> internals provide proper methods for this
> 
> - tty_mode_ioctl()
> 
> 	This handles all the terminal mode handling for speed/carrier etc
> and none of the methods are ldisc dependant so they can be called by any
> user
> 
> - tty_perform_flush()
> 
> 	This extracts the flush functionality and enables pppd the ppp
> layer to share it cleanly.
> 
> 
> The existing n_tty_ioctl code is refactored in this patch to provide the
> new functions and to call them itself appropriately. This patch has no
> (intended) behaviour changes and simply prepares for the other fixes.

net/irda/irnet/irnet_ppp.c: In function 'dev_irnet_ioctl':
net/irda/irnet/irnet_ppp.c:738: warning: passing argument 2 of 'kernel_termios_to_user_termios_1' from incompatible pointer type
net/irda/irnet/irnet_ppp.c:750: warning: passing argument 1 of 'user_termios_to_kernel_termios_1' from incompatible pointer type
