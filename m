Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYDRPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYDRPUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYDRPUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:20:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57408 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYDRPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:20:30 -0400
Date: Fri, 18 Apr 2008 08:20:14 -0700
From: Greg KH <greg@kroah.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Problem with delayed data from pl2303 usb serial gps
Message-ID: <20080418152014.GA5845@kroah.com>
References: <480874E8.7040903@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480874E8.7040903@aitel.hist.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 12:16:08PM +0200, Helge Hafting wrote:
> Problem:
> I run car navigation software on linux, using a gps.
> Getting data from the gps unit in a timely fashion is important, as
> the software says thing like "turn left in 50m". That is useless however,
> if the message arrives 10s after you passed the intersection!

That sounds like a problem either in the device, or in the pl2303 chip,
or possibly, your userspace program.

As a test, enable debugging in the pl2303 driver:
	modprobe pl2303 debug=1
or enable it after it is loaded with:
	echo 1 > /sys/module/pl2303/parameters/debug

and run your program.  Look at the timestamps in the kernel log for when
the pl2303 driver gets your data and compare it to when your userspace
program is getting them.

Let me know if you find anything we can help out with.

thanks,

greg k-h
