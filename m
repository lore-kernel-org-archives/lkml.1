Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXBRND3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXBRND3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 08:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXBRND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 08:03:28 -0500
Received: from thunk.org ([69.25.196.29]:42830 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXBRND2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 08:03:28 -0500
Date: Sun, 18 Feb 2007 08:03:20 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mockern <Mockern@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial and tty driver
Message-ID: <20070218130320.GA20321@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Mockern <Mockern@yandex.ru>,
	linux-kernel@vger.kernel.org
References: <45D73BF6.000001.30155@pantene.yandex.ru> <45D74856.6090900@microgate.com> <20070217232054.GA11117@thunk.org> <45D813EA.000008.23689@soapbox.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D813EA.000008.23689@soapbox.yandex.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 11:52:58AM +0300, Mockern wrote:
> Thank you for you respond.
> 
> I asked this question since I have one problem with my tty driver.
> It based on serial_core.c. It works well except Linux cat operation:(.
> (e.g. cat < ttyS10). I thought in tty driver there is no function
> for this operation and I wanted to know that maybe serial driver has it.
> 
> Could it be the reason that cat operation in tty driver does not work
> (but I can write and read from user space application!)?
> Or maybe I need to implement a special function in my tty driver to support Linux
> cat operation?

If you do something like "cat < ttyS10" it will work by opening the
device just like a user space application --- but the shell, which is
opening /dev/ttyS10, won't use any of the special flags that a user
space application might use to not wait for the carrier detect line to
go high, for example.  

I'd have to see the sources of the driver and your user space
application to be sure, but one thing you should try is "stty -F
/dev/ttyS10 clocal" and see if that allows "cat < /dev/ttyS10" to
work.  

Regards,

						- Ted
