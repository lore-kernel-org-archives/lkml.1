Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbYFWTyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbYFWTyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762104AbYFWTxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:53:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:56470 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762057AbYFWTxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:53:54 -0400
Date: Mon, 23 Jun 2008 12:53:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix open/close race in saa7134
Message-ID: <20080623125348.3133b30b@infradead.org>
In-Reply-To: <20080623192141.GB5593@joi>
References: <20080622100507.779acc59@infradead.org>
	<20080622172826.GA7487@joi>
	<20080622105832.1c61fb92@infradead.org>
	<20080623184937.GA5593@joi>
	<20080623115432.5ce376e5@infradead.org>
	<20080623192141.GB5593@joi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 21:22:03 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> 
> If dev->empress_users could be > 1 then ok - it could break, but it
> can only be 1 or 0. If it's 1 you won't open the device. If it's 0
> you won't reach ts_close.
> 
> If you still see the race, please show me the sequence, because I
> don't (of course when decrementing is the last operation of ts_close).

a decrement in C, without locking, is NOT atomic.
It in fact is 
"load variable into register"
"increment register value"
"write register to variable"

which the compiler then takes and orders for maximum performance....



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
