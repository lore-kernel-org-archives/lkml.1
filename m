Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZHMSQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZHMSQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZHMSQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:16:33 -0400
Received: from kroah.org ([198.145.64.141]:43418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbZHMSQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:16:32 -0400
Date: Thu, 13 Aug 2009 11:15:21 -0700
From: Greg KH <greg@kroah.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Combine two one-character CR-LF writes into one
 two-character write for O_ONLCR
Message-ID: <20090813181521.GB28172@kroah.com>
References: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:54:30AM -0700, David VomLehn wrote:
> When handling output of a newline character in O_ONLCR mode, the n_tty.c
> do_output_char() function uses the struct tty_operations function write_room()
> to determine whether it is possible to write two characters. It uses
> tty_put_char() for each character which, for the USB generic serial driver,
> translates into a write() for each character. For the USB generic serial
> driver the value returned by write_room() only applies to the next write().
> A second write() done in quick succession will fail because the write URB
> buffer is still busy from the first write(). In this case, it results in the
> printing of a carriage return without the following line feed.

How about fixing the usb-serial generic driver to properly handle stuff
like this instead?  It should be using a fifo and not the stupid method
it currently is.

Anyway, what device are you using that uses the usb-serial generic
driver that you are seeing this problem with?

thanks,

greg k-h
