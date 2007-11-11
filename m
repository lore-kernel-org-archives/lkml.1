Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXKKU2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXKKU2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXKKU2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:28:13 -0500
Received: from nn7.de ([85.214.94.156]:57920 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbXKKU2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:28:12 -0500
Subject: Re: 2.6.23: no more free evdev devices - evdev leak?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711061551570.16120@twin.jikos.cz>
References: <1193848484.5070.41.camel@localhost>
	 <20071105191341.9b9dd857.akpm@linux-foundation.org>
	 <d120d5000711060606h66adacd8q4c1576f98389bf41@mail.gmail.com>
	 <Pine.LNX.4.64.0711061551570.16120@twin.jikos.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Nov 2007 21:28:06 +0100
Message-Id: <1194812886.5404.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 15:52 +0100, Jiri Kosina wrote:
> On Tue, 6 Nov 2007, Dmitry Torokhov wrote:
> 
> > Could you please try sticking a printk in 
> > hidinput_disconnect(drivers/hid/hid-input.c) to verify that 
> > input_unregister_device is in fact being called?
> 
> Also, is 2.6.23 the only kernel you are experiencing this with please?

So far yes. I am now on 2.6.24rc2 and although the input device numbers
steadily increase s2ram does reliably work even when done >10 times in a
row and no problems with evdev devices not being available.

However resume is slower as some ata device (I think my cdrom) is timing
out. So it could be related to a too fast resume from suspend.

So the problem may re-appear if matthew garrets fix for
[PATCH] Don't fail ata device revalidation for bad _GTF methods

will be committed.

Is there still a need to do tests with the printk's in 2.6.23?

Soeren
