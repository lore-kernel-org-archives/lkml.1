Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXAaKt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXAaKt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933005AbXAaKt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:49:27 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:21960 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbXAaKt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Y+6cXssd+7aA8oRLVvG9VOzK8IUC4XDR3hFbnUKFZaAWx3xdgGar17hEaNRQtz5WpJX1KhMmHKjmBjPNq6zpE5/+IJ2JsbCzgtJNRiqjWISYaXQhsJvRvub86a6iNzBn79rAlNPW22Po0Mp3MAuRmzsHIsOv4lKXtoVYAQni0jE=
Message-ID: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com>
Date: Wed, 31 Jan 2007 18:49:25 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG]: 2.6.19.2: Weird serial core issue
Cc: linux-serial@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I insert one printk into drivers/serial/serial_core.c:
uart_set_termios() to describe the issue.
static void uart_set_termios(struct tty_struct *tty, struct termios
*old_termios)
{
 ----snip----
        unsigned int cflag = tty->termios->c_cflag;

        BUG_ON(!kernel_locked());
+++printk("new_termios flag: 0x%x, old_termios flag: 0x%x\n");
+++             cflag, old_termios->c_cflag);

----snip ----
}

When I telnet my board and run the following command:
---- root:~> stty -F /dev/ttyS0 -crtscts

I got the following result from the console of my board:
---- root:~>new_termios flag: 0x1cb1, old_termios flag: 0x80001cb1

That's correct. CRTSCTS flag is clear

But when I type "ENTER" key on the console, I got:
----root:~>new_termios flag: 0x80001cb1, old_termios flag: 0x1cb1

The CRTSCTS flag is set back. But I didn't set it back, I just type "ENTER".
I guess, Is it a serial core bug?

-Aubrey
