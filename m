Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYJAMxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYJAMxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJAMwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:52:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbYJAMwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:52:50 -0400
Date: Wed, 1 Oct 2008 08:52:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       kaszak@gmail.com, lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und wifi driver for linux-staging
Message-ID: <20081001125248.GA29661@infradead.org>
References: <20081001123656.GA30942@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001123656.GA30942@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 02:36:56PM +0200, Pavel Machek wrote:
> +source "drivers/net/wireless/winbond/Kconfig"

winbond is a little too generic, please use the same name as the driver
name for the directory.

> @@ -0,0 +1,6 @@
> +config W35UND
> +	tristate "Winbond driver"
> +	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL && !4KSTACKS
> +	---help---
> +	  This is highly experimental driver for winbond wifi card on some Kohjinsha notebooks
> +	  Check http://code.google.com/p/winbondport/ for new version

Again, please give the option a useful name, and a useful description
including mentioning the actual chip name in there.

Also the !4KSTACKS dependency looks rather odd.

> diff --git a/drivers/net/wireless/winbond/Makefile b/drivers/net/wireless/winbond/Makefile
> new file mode 100644
> index 0000000..4682dd1
> --- /dev/null
> +++ b/drivers/net/wireless/winbond/Makefile
> @@ -0,0 +1,17 @@
> +	BASE_DIR=./winbondport
> +	DRIVER_DIR=./winbondport/linux
> +
> +obj-m := w35und.o
> +
> +w35und-objs := $(DRIVER_DIR)/wbusb.o $(DRIVER_DIR)/wb35reg.o $(DRIVER_DIR)/wb35rx.o $(DRIVER_DIR)/wb35tx.o \
> +	$(BASE_DIR)/mds.o \
> +	$(BASE_DIR)/mlmetxrx.o \
> +	$(BASE_DIR)/mto.o $(BASE_DIR)/phy_calibration.o $(BASE_DIR)/reg.o \
> +	$(BASE_DIR)/rxisr.o \
> +	$(BASE_DIR)/sme_api.o $(BASE_DIR)/wbhal.o $(BASE_DIR)/wblinux.o  \
> +
> +
> +obj-$(CONFIG_W35UND) += w35und.o

This is not a proper Makefile, and having these files in subdirectories
is not really a good idea either.  So move all files into one directory
and write a proper Makefile for it:

w35und-y	+= wbusb.o wb35reg.o wb35rx.o wb35tx.o mds.o mlmetxrx.o \
		   mto.o phy_calibration.o reg.o rxisr.o sme_api.o wbhal.o \
		   wblinux.o

obj-$(CONFIG_W35UND)	+= w35und.o

> diff --git a/drivers/net/wireless/winbond/winbondport/Makefile b/drivers/net/wireless/winbond/winbondport/Makefile
> new file mode 100644
> index 0000000..b03564c
> --- /dev/null
> +++ b/drivers/net/wireless/winbond/winbondport/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for the Winbond wireless networking driver
> +#
> +	
> +include $(TOPDIR)/Rules.make

This looks like some 2.4 leftover.

> diff --git a/drivers/net/wireless/winbond/winbondport/SVN_CHANGELOG b/drivers/net/wireless/winbond/winbondport/SVN_CHANGELOG
> new file mode 100644

should not be in the git tree.

> +++ b/drivers/net/wireless/winbond/winbondport/VersionNote.txt

neither.


No comments on the code now, I don't think I want to look at it..

