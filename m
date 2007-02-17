Return-Path: <linux-kernel-owner+w=401wt.eu-S965300AbXBQPRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbXBQPRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965299AbXBQPRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:17:31 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:55559 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965289AbXBQPRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:17:30 -0500
Date: Sat, 17 Feb 2007 10:17:29 -0500
To: Mockern <Mockern@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: buffer overflows in the tty flip buffer in 2.6.17
Message-ID: <20070217151729.GS7584@csclub.uwaterloo.ca>
References: <45D6F52B.000003.10185@webmail19.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D6F52B.000003.10185@webmail19.yandex.ru>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 03:29:31PM +0300, Mockern wrote:
> When data is received from the hardware, it needs to be placed into the tty device's flip buffer. This can be done with the following bit of code:
> 
> for (i = 0; i < data_size; ++i) {
>         if (tty->flip.count >= TTY_FLIPBUF_SIZE)
>                 tty_flip_buffer_push(tty);
>         tty_insert_flip_char(tty, data[i], 0);
> }
> tty_flip_buffer_push(tty);
> 
> This example makes sure there are no buffer overflows in the tty flip buffer as the data is being added. 
> 
> But how it is done in 2.6.17 linux kernel? I did check this "overflow code" in new tty driver's code. This code looks like just removed. But somehow overflow in the tty buffer must be kept.

Well there was a problem in 2.6.16, which was fixed by 2.6.18, although
I am not sure if it was done by 2.6.17.  It would loose characters due
to buffer overflow and not properly checking under high load.  I grabbed
a few patches from the git tree that were added after 2.6.16 to fix the
tty problems I was having.

--
Len Sorensen
