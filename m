Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbXJWPEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbXJWPEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXJWPEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:04:30 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46460 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858AbXJWPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:04:29 -0400
Date: Tue, 23 Oct 2007 11:04:29 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Message-ID: <20071023150429.GK4003@csclub.uwaterloo.ca>
References: <471CDC5E.4010300@linux.intel.com> <20071022114001.40470c15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022114001.40470c15.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 11:40:01AM -0700, Andrew Morton wrote:
> - Here:
> 
> +		if (0 == memcmp(&heci_wd_guid,
> 
>   we boringly prefer "if (foo == 0)" rather than "if (0 == foo)".  (lots
>   of places).

But 0 == blah is safer.  If you accidentally do 0 = blah the compiler
will tell you.  Just because people have always done it the other way
around doesn't make it the right way to do it.  I have noticed many
people have started to realize this in the last few years.

It is also much clearer that you are comparing against a constant and
not doing an assignment when the constant comes before the variable.

I think to encourage people doing it the less safe way is just silly.

Some places in the kernel that already uses the constant first are:

./sound/oss/btaudio.c
./sound/usb/usx2y/
./net/sctp/
./arch/x86_64/mm/init.c
./arch/cris/arch-v32/drivers/cryptocop.c
./drivers/i2c/algos/i2c-algo-pcf.c
./drivers/mtd/devices/doc2000.c
./drivers/net/iseries_veth.c
./drivers/net/hp100.c
./drivers/net/phy/phy.c
./drivers/net/xen-netfront.c
./drivers/scsi/scsi_error.c
./drivers/scsi/sr_ioctl.c
./drivers/scsi/ch.c
./drivers/scsi/sg.c
./drivers/scsi/sr_vendor.c
./drivers/scsi/scsi_debug.c
./drivers/media/video/tea6415c.c
./drivers/media/video/tvaudio.c
./drivers/media/video/bt8xx/
./drivers/char/ip2/
./drivers/isdn/hisax/
./drivers/sbus/char/
./fs/nfsd/

and I am sure there a quite a few more.  It ought to be encouraged for
all new code to avoid stupid typo bugs that are hard to see.

--
Len Sorensen
