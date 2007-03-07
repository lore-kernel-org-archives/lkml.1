Return-Path: <linux-kernel-owner+w=401wt.eu-S965370AbXCGQdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370AbXCGQdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965180AbXCGQdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:33:10 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45287 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965370AbXCGQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:33:09 -0500
Date: Wed, 7 Mar 2007 17:32:29 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Jon Ringle <JRingle@vertical.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: tiny tty driver sample
In-Reply-To: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>
Message-ID: <Pine.LNX.4.64.0703071730190.10909@twin.jikos.cz>
References: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Jon Ringle wrote:

> I'm trying to write a tty driver and I'm using 
> http://lwn.net/images/pdf/LDD3/ch18.pdf as a guide. The sample tiny tty 
> driver includes the following code:
>             for (i = 0; i < data_size; ++i) {
>                         if (tty->flip.count >= TTY_FLIPBUF_SIZE)
>                                     tty_flip_buffer_push(tty);
>                         tty_insert_flip_char(tty, data[i], TTY_NORMAL);
>             }
>             tty_flip_buffer_push(tty);
> This doesn't compile against Linux 2.6.16 kernel I'm using, because 
> tty->flip.count doesn't exist anymore. How should this sample be 
> re-coded?

I guess something like

	tty_buffer_request_room(tty, data_size);
	for (i = 0; i < data_size; ++i)
		work += tty_insert_flip_char(tty, data[i], TTY_NORMAL);
	if (work)
		tty_flip_buffer_push(tty);

will do.

-- 
Jiri Kosina
