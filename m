Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYGUUxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYGUUxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYGUUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:53:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42729 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752307AbYGUUxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:53:07 -0400
Date: Mon, 21 Jul 2008 17:32:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: Re: [Patch] um: fix a build error
Message-ID: <20080721173226.0c0462f7@the-village.bc.nu>
In-Reply-To: <20080721165409.GA9023@hack.voiplan.pt>
References: <20080721165409.GA9023@hack.voiplan.pt>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 17:54:09 +0100
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> 
> Fixed this build error:
> 
> /home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c: In function
> ‘line_write_interrupt’:
> /home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:366: error:
> ‘struct tty_ldisc’ has no member named ‘write_wakeup’
> /home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:367: error:
> ‘struct tty_ldisc’ has no member named ‘write_wakeup’
> make[2]: *** [arch/um/drivers/line.o] Error 1
> make[1]: *** [arch/um/drivers] Error 2
> make: *** [sub-make] Error 2
> 
> Sigend-off-by: WANG Cong <wangcong@zeuux.org>

NAK - drivers shouldn't be poking around in tty innards in the first
place then this wouldn't break. Use tty_wakeup(tty); insteaad

Alan
