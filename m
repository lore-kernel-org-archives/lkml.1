Return-Path: <linux-kernel-owner+w=401wt.eu-S1750863AbXB0Vqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbXB0Vqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXB0Vqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:46:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55120 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXB0Vqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:46:54 -0500
Date: Tue, 27 Feb 2007 21:46:42 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] display class
In-Reply-To: <20070227122531.542a2c33.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702272133170.21161@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702251833500.30828@pentafluge.infradead.org>
 <20070227122531.542a2c33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> this stuff looks el-crappo in an 80-col display.

Cleaning up....

> This guy can have static scope.
> 
> It's a bit awkward having a fixed size.  I think lib/idr.c would suit for
> this.
>
> Also, we do set_bit() and clear_bit() on this, which are needlessly atomic. 
> If we hold a suitable lock then we can use __set_bit() and __clear_bit().
> 
> And we do need a suitable lock.

Fixing... Never knew about idr. Hum nice :-) I will have a new patch your 
way. I just need to do some teste first.

> Why all the ifdeffery?  I think plain old
> 
> 
> static void __exit display_class_exit(void)
> {
> 	class_destroy(display_class);
> }
> module_exit(display_class_exit);
> module_init(display_class_init);

That is from the hunting of the bug with the broken symlinks in /sys. Will 
go back to sanity.
