Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYICKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYICKJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYICKJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:09:47 -0400
Received: from mailer1.option.com ([81.246.70.162]:44969 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYICKJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:09:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgBAFf/vUgKAAAZ/2dsb2JhbAAItg2BaQ
Message-ID: <48BE5903.1040207@option.com>
Date: Wed, 03 Sep 2008 11:29:39 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Bird <ajb@spheresystems.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jeff Garzik <jgarzik@pobox.com>
Subject: re /drivers/char/n_tty.c drops characters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 10:09:44.0588 (UTC) FILETIME=[30325CC0:01C90DAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
It looks like the it was the intention that n_tty.c
would not drop characters in older kernels around 2.6.15 in the
n_tty layer if N_TTY_BUF_SIZE was 4096 bytes
as TTY_FLIPBUF_SIZE was only 512 bytes.

Now since 2.6.15 or so tty_buffer_alloc in tty_io.c is capible
of allocating a tty buffer of over 64k I believe this
means that the n_tty_receive_buf will overflow if tty_buffer_alloc 
throws a buffer of over 4k to n_tty_receive_buf.

Any comments?

-- 
best regards,
D.J. Barrow
