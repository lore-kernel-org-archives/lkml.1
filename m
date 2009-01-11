Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZAKWrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZAKWrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZAKWrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:47:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:33234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZAKWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:46:59 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: David Miller <davem@davemloft.net>, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <99827.1231712979@turing-police.cc.vt.edu>
References: <1231676698.25018.147.camel@macbook.infradead.org>
	 <1231678799.25018.195.camel@macbook.infradead.org>
	 <58054.1231692502@turing-police.cc.vt.edu>
	 <20090111.134937.135396505.davem@davemloft.net>
	 <99827.1231712979@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 22:46:20 +0000
Message-Id: <1231713980.25018.708.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 17:29 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 11 Jan 2009 13:49:37 PST, David Miller said:
> > From: Valdis.Kletnieks@vt.edu
> > Date: Sun, 11 Jan 2009 11:48:22 -0500
> > 
> > > One unanswered question:  What do we expect the system to do if they have this
> > > patch, TIGON3=y, FIRMWARE_IN_KERNEL=n, and configure a netconsole for boot
> > > messages?  I'm *hoping* the answer is "the netconsole doesn't come up at boot,
> > > but can be re-enabled via the /sys/kernel/config/netconsole interface after
> > > you've done an 'ifconfig eth0 up' or similar, or do a 'modprobe netconsole'.
> > > 
> > > Those seem like reasonable semantics to me - anybody got a different opinion?
> > 
> > Even better, how about nfsroot?  There is no "later", either you
> > can mount to root filesystem or you fail.
> 
> I don't see any sane way for an nfsroot to work unless you've built the kernel
> with TIGON3=y, and FIRMWARE=y.  Anything else is just crazy talk.  For that
> case, I'd suggest we just do this:
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> --- linux-2.6.28-mmotm0109/Documentation/filesystems/nfsroot.txt.dist	2008-12-24 18:26:37.000000000 -0500
> +++ linux-2.6.28-mmotm0109/Documentation/filesystems/nfsroot.txt	2009-01-11 17:27:31.000000000 -0500
> @@ -30,6 +30,9 @@ In the networking options, kernel level 
>  along with the types of autoconfiguration to support. Selecting all of
>  DHCP, BOOTP and RARP is safe.
>  
> +In addition, your network interface driver must be selected as built-in,
> +and if the card is a Tigon3 or other card that requires a firmware load
> +to become functional, you need to select FIRMWARE_IN_KERNEL.

Yeah, but it's not FIRMWARE_IN_KERNEL in the general case -- that's just
for a handful of 'speshul' legacy drivers. In the general case it's the
CONFIG_EXTRA_FIRMWARE option which needs to be set to include the
required firmware.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

