Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbXEMQ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbXEMQ3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759098AbXEMQ2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:28:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbXEMQ2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:28:51 -0400
Date: Sun, 13 May 2007 12:28:48 -0400
From: Dave Jones <davej@redhat.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Message-ID: <20070513162848.GD27604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain> <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 11:10:55AM -0500, James Bottomley wrote:

 > > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
 > > index e62d23f..0f6c370 100644
 > > --- a/drivers/scsi/Kconfig
 > > +++ b/drivers/scsi/Kconfig
 > > @@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
 > >  config SCSI_WAIT_SCAN
 > >  	tristate
 > >  	default m
 > > -	depends on SCSI
 > > +	depends on SCSI_SCAN_ASYNC
 > 
 > No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
 > wait scan to be built in, which isn't the idea at all.

hmm?

with my change...

$ make defconfig
$ grep SCSI_SCAN_ASYNC .config
# CONFIG_SCSI_SCAN_ASYNC is not set
$ grep SCSI_WAIT_SCAN .config

<edit .config to remove the CONFIG_SCSI_SCAN_ASYNC line>
$ make oldconfig
<answer 'y' for CONFIG_SCSI_SCAN_ASYNC>

$ grep SCSI_SCAN_ASYNC .config
CONFIG_SCSI_SCAN_ASYNC=y
$ grep SCSI_WAIT_SCAN .config
CONFIG_SCSI_WAIT_SCAN=m


	Dave

-- 
http://www.codemonkey.org.uk
