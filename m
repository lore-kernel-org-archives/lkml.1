Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbXEHUdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbXEHUdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXEHUdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:33:10 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:32961
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbXEHUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:33:09 -0400
Subject: Re: [PATCH] Use tty_schedule in VT code.
From: Paul Fulghum <paulkf@microgate.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0705082107460.3459@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0705082107460.3459@pentafluge.infradead.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 15:32:41 -0500
Message-Id: <1178656361.14867.7.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 21:10 +0100, James Simmons wrote:
> 
> This patch has the VT subsystem use tty_schedule_flip instead of 
> con_schedule_flip. There are two ways we can approach this. We can
> do the below path or extend tty_schedule_flip to accept a time field.
> Comments welcomed.

This looks reasonable.

I don't think a time field is necessary. In fact, I think the
scheduled_delayed_work() in tty_schedule_flip() should use a
time of 0 just like con_schedule_flip().

As the tty flip buffer code has evolved, that delay value of 1
was carried along. It may have had some historical purpose, but
I can't figure it out and it appears to have no use currently.

It would be better for performance to process the receive data
as soon as possible (delay value of 0).


--
Paul Fulghum
Microgate Systems, Ltd

