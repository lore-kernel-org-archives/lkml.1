Return-Path: <linux-kernel-owner+w=401wt.eu-S1422641AbXCBADc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641AbXCBADc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422637AbXCBADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:03:18 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:45276 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422644AbXCBADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ki/lEOjz1TC9w6EEOG3eduE3ow66RdIVbRoGq1Y7wgUl9hF+/Z6+p6U8lkRKpTwxv0f0vMCJQjSQZgt+ZZDn9ioGkSMrjNeCtTk2Jkw0H5l464a27SDijVlacQL5Rm49zpfY1Z6jKJc0mJLfgu2pCcENmPlFC9A8SfXApBVrKKA=
Message-ID: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
Date: Thu, 1 Mar 2007 19:03:02 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: rmk@arm.linux.org.uk
Subject: should RTS init in serial core be tied to CRTSCTS
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, "Robin Getz" <rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the console= bootcmd allows for controlling of the initial state of
flow control by adding/omitting the 'r' suffix ... however, the
uart_startup() function in serial_core.c always calls down into the
serial driver with TIOCM_RTS:
static int uart_startup(...) {
...
            /*
             * Setup the RTS and DTR signals once the
             * port is open and ready to respond.
             */
            if (info->tty->termios->c_cflag & CBAUD)
                uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
...

shouldnt TIOCM_RTS be passed down only when the 'r' is appended to the
boot cmdline ?  perhaps like this:
uart_set_mctrl(port, (info->flags & UIF_CTS_FLOW ? TIOCM_RTS : 0) | TIOCM_DTR);
assuming too that TIOCM_DTR should always be set ...
-mike
