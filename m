Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbZHUPsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbZHUPsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZHUPsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:48:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56902 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754280AbZHUPsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:48:07 -0400
Date: Fri, 21 Aug 2009 16:48:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090821164843.639aedaf@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0908211042380.2912-100000@iolanthe.rowland.org>
References: <20090821112554.18a297fa@pluto.restena.lu>
	<Pine.LNX.4.44L0.0908211042380.2912-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, related to this problem is the fact that usb_serial_driver
> doesn't include a "hangup" method.  I'm not sure that making
> serial_hangup() call serial_do_down() is correct, but if it is then
> shouldn't we call port->serial->type->open() afterwards?  Otherwise the
> lower driver can't know that the port is still open.

After a hangup the port isn't open (at the physical level anyway). It may
be re-opened by another open() call later but the original user lost
access to it and shouldn't touch the h/w post hangup completion.

> Furthermore, shouldn't we check ASYNCB_INITIALIZED in serial_close()?

Possibly - I was in the middle of debugging the newest bits when Linus
annoyed me. Certainly there are issues in the current code if you get
a hangup while waiting for open to complete. I fixed that in the patches
I sent Greg but didn't finish debugging it.

