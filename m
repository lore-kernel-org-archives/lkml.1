Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZK3PhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZK3PhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZK3PhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:37:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42629 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752187AbZK3PhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:37:08 -0500
Date: Mon, 30 Nov 2009 15:39:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth cf slow (10KB/sec), lots of dmesg spam
Message-ID: <20091130153915.0a6910e3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091129155801.GA1634@ucw.cz>
References: <20091129155801.GA1634@ucw.cz>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe the problem is 115200 bitrate between system and CF serial;

and lack of flow control I assume ?

> I did setserial baud_base 921600,  but that does not seem to speed it
> up. Do I need to do some special magic to enable high speed?

Just set the baud rate to 921600. You may need to write an app to do this
directly via the TERMIOS2 ioctl because it seems three years ago is a bit
quick for the glibc maintainers to keep up.

Basically set the baud to BOTHER, set the ispeed = ospeed = 921600 and
the kernel will do its best to give you your request

Alan
