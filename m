Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbYH2Ojn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbYH2Ojn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYH2Ojf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:39:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbYH2Oje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:39:34 -0400
Date: Fri, 29 Aug 2008 07:39:02 -0700
From: Greg KH <greg@kroah.com>
To: stefan_kopp@agilent.com
Cc: korgull@home.nl, stern@rowland.harvard.edu, oliver@neukum.org,
       linux-usb@vger.kernel.org, me@felipebalbi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
	2
Message-ID: <20080829143902.GC18136@kroah.com>
References: <20080827183615.GA15692@kroah.com> <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org> <20080827234720.GC31264@kroah.com> <200808281858.42486.korgull@home.nl> <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:57:54AM -0600, stefan_kopp@agilent.com wrote:
> Hi all,
> 
> I haven't been able to follow all the enhancements you did to the
> driver, but I can comment on the ratioale behind the orignal driver.
> 
> The original driver used minor number 0 for "driver communication" (in
> contrast to "device communication"). The main purpose was to get a
> list of the USBTMC devices attached by doing a "cat /dev/usbtmc0"
> (which would point to minor number 0). The first device found would
> then use the next free minor number, usually 1. I believe the concept
> of "driver communication" has been removed from the driver, so a
> single minor number for a single device should be it.

cating that file was sending out a text file to userspace that needed to
be parsed, like a /proc file.  Now you can just look at all of the
devices in /sys/class/usb/usbtmc* to see all of the different devices in
the system.

> The issue with using cat on the shell level is that it uses fread
> which has the (in this case) ugly behaviour of recalling the driver's
> read method until the full number of characters requested has been
> accumulated (or until zero characters are returned, indicating the end
> of file). With USBTMC instruments, this behavour is bad because the
> retry will not just return zero characters, it will cause a timeout
> with the associated error condition in the device. So, to enable the
> use of echo/cat, I added some fread handling to the driver (which
> catches the retries). I believe this also has been removed, so I
> assume cat/fread will not work (?).

I do not know, but we do not do wierd things in the kernel just because
of broken userspace programs.  This logic should be done in userspace,
and programs should look at the return value of read() and handle it
properly.  Otherwise it is a bug.

thanks,

greg k-h
