Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbXAXUkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbXAXUkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbXAXUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:40:11 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:40054 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932578AbXAXUkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:40:10 -0500
Date: Wed, 24 Jan 2007 15:40:09 -0500
To: linux-kernel@vger.kernel.org
Subject: Strange problem with tty layer
Message-ID: <20070124204009.GA7584@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing a very strange problem which seems to be in the tty layer.

I am using an exar 17D154 based PCI card (like the digi neo style card)
using the jsm driver.  Kernel version 2.6.16.25.

My test involves connecting two ports together with a cross over cable
and then sending a test pattern of characters.  I am currently using
11520 characters at 230400bps (so 0.5s for the transfer).

Most of the time, it works perfectly, but once in a while, I never
receiver the last few characters (between 1 and 65 or so characters it
seems).

I have confirmed that the driver does in fact receive all the
characters, and that they are correct, and that they are being passed to
the tty layer using tty_insert_flip_string, and that it returns that all
the characters have been passed to the tty layer.  The user space
application however still doesn't see the last few characters (when it
fails).

The problem seems to occour every few hours of testing on a 266MHz Geode
SC1200.  When I change the clock to 133MHz, it happens every few minutes
instead (so much more frequently).  I suspect there is some race
condition that allows the tty layer to not get around to processing all
the data in the buffer, even when asked for data by the application
(which is waiting on the serial port using select, with a 4s timeout).

Any suggestions on where to head next to debug this?

Sending a few more characters when the receive times out before getting
the complete message does not cause the missing data to arive it seems,
only completely closing and starting the test program again seems to
recover it, although I may just not have been patient enough.

--
Len Sorensen
