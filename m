Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbZHNUSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbZHNUSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZHNUSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:18:16 -0400
Received: from kroah.org ([198.145.64.141]:50977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbZHNUSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:18:15 -0400
Date: Fri, 14 Aug 2009 13:15:04 -0700
From: Greg KH <greg@kroah.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] Use kfifo to buffer USB generic serial writes
Message-ID: <20090814201504.GA19868@kroah.com>
References: <20090814200251.GA26258@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814200251.GA26258@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 01:02:51PM -0700, David VomLehn wrote:
> When do_output_char() attempts to write a carriage return/line feed sequence,
> it first checks to see how much buffer room is available. If there are at least
> two characters free, it will write the carriage return/line feed with two calls
> to tty_put_char(). It calls the tty_operation functions write() for devices that
> don't support the tty_operations function put_char(). If the USB generic serial
> device's write URB is not in use, it will return the buffer size when asked how
> much room is available. The write() of the carriage return will cause it to mark
> the write URB busy, so the subsequent write() of the line feed will be ignored.
> 
> The first part of patch uses the kfifo infrastructure to implement a write
> FIFO that accurately returns the amount of space available in the buffer. The
> second makes a minor change to kfifo_put() and __kfifo_put() to add the "const"
> attribute to their input buffer pointers.
> 
> Signed-off-by: David VomLehn

Yeah!

Thanks so much for doing this work, I'll go queue it up and test it
right away.  I really appreciate it.

greg k-h
