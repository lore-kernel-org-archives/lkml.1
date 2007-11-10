Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXKJPod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXKJPod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbXKJPnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:43:21 -0500
Received: from mail.suse.de ([195.135.220.2]:32957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbXKJPnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:43:19 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC! 10/13] Char: nozomi, fix tty_flip_buffer_push
Date: Sat, 10 Nov 2007 16:43:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <259691270825982947.slaby@pripojeni.net>
In-Reply-To: <259691270825982947.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101643.17270.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:49:32, you (Jiri Slaby) wrote:
> Especially on this I would like to see feedback. Unlock and lock the
> spinlock just around the tty_flip_buffer_push would be much more easier, but
> won't it break anything?
> --
> nozomi, fix tty_flip_buffer_push
> 
> tty_flip_buffer_push call may deadlock when invoking it while holding
> spinlock used in e.g. throttle too. Nozomi sets low_latency tty and that
> means, that ldisc flush will be called immediately and it can call some
> nozomi functions back. Solve it by invoking tty_flip_buffer_push after
> releasing the spinlock.

IMHO its a brilliant idea to defer it this way to a safe place. I just
had to adapt the type of flip to "usigned long" (otherwise gcc spits
warnings around).
Eventhough i never ran in such a deadlock of course it looks much safer
now this way. I tested this patch and it seems to not break anything.

Applied without changes.

Thanks a lot,
Frank
