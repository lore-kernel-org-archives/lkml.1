Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZIQJNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZIQJNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbZIQJNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:13:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59867 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756588AbZIQJNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:13:15 -0400
Date: Thu, 17 Sep 2009 10:14:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
Message-ID: <20090917101441.478b3e9b@lxorguk.ukuu.org.uk>
In-Reply-To: <4AB1B860.4080105@windriver.com>
References: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org>
	<4AB1B860.4080105@windriver.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looked like the API for the tty subsystem was gradually changing such
> that the ldisc structure could ultimately get shared for use with the
> console, but this work is not complete, so we are somewhere in between.

The mechanics of this are already there. A tty drive can manage its own
termios structs, and the termios structs are pointers in the tty structure

> The question is what is an acceptable solution?

Take a look at usb_serial.c:serial_install. You can do the console state
preservation there and cleanly.

