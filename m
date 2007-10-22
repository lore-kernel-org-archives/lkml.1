Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbXJVCra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbXJVCra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXJVCrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:47:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47834 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957AbXJVCrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:47:04 -0400
Date: Mon, 22 Oct 2007 04:47:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: char/cyclades.c: inconsequent NULL checking
Message-ID: <20071022024734.GI30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in 
drivers/char/cyclades.c:

<--  snip  -->

...
static void cyz_handle_tx(struct cyclades_port *info,
                struct BUF_CTRL __iomem *buf_ctrl)
{
        struct cyclades_card *cinfo = info->card;
        struct tty_struct *tty = info->tty;
...
                if (tty == NULL)
                        goto ztxdone;
...
                tty_wakeup(tty);
...

<--  snip  -->

Nothing in cyz_handle_tx() seems to change "tty".

The "tty_wakeup(tty);" was added in commit 
ebafeeff0fea029099e9952f233e0794106897a6.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

