Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZLVRU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZLVRU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZLVRUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:20:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:60850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbZLVRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:20:55 -0500
Subject: Re: WARN_ON at line 380 in kernel/smp.c under 2.6.32.2 + TuxOnIce
 + KDB
From: Peter Zijlstra <peterz@infradead.org>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nigel Cunningham <nigel@tuxonice.net>
In-Reply-To: <74fd948d0912220851v354b1704xa55fc3c88e1c300c@mail.gmail.com>
References: <74fd948d0912220851v354b1704xa55fc3c88e1c300c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 18:20:31 +0100
Message-ID: <1261502431.4937.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 16:51 +0000, Pedro Ribeiro wrote:
> Hi all,
> 
> I've been asked by Nigel Cunningham of TuxOnIce to forward this bug here.
> 
> While resuming from hibernate (using TuxOnIce) I'm seeing the WARN_ON
> at line 380 in kernel/smp.c trigger from a kmap_high call right after
> secondary processors have been brought down (the previous message is
> "CPU1 is down").
> 
> I only have pictures of the backtrace (readable but not very good
> quality, sorry).
> http://img51.imageshack.us/img51/2312/stacktrace1.jpg
> http://img195.imageshack.us/img195/3646/stacktrace2.jpg
> 
> At first I thought this was related to my battery saving script
> messing with /proc/sys/vm/dirty_writeback_centisecs, but I'm not sure
> right now, it still happens with the default value, so I'm clueless.
> 
> Mind you, this does not impede the resume - it just dumps this stack
> trace and continues resuming happily.

If you'd enable frame pointers the strack traces would be clearer, but
it looks like a bug in tux on ice, doing kmap_high() with IRQs disabled
or something like that.

