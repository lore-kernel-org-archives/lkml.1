Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYAFSCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYAFSCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYAFSCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:02:01 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60258 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbYAFSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:02:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47811770.4040706@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 19:01:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
References: <200801051546.SAA08947@raad.intranet> <200801060803.27101.a1426z@gawab.com> <4780E814.4050405@s5r6.in-berlin.de> <200801062007.31516.a1426z@gawab.com> <478114F3.6020804@s5r6.in-berlin.de>
In-Reply-To: <478114F3.6020804@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Al Boldi wrote:
>> Stefan Richter wrote:
>>> Still wrong. SCSI also needs HAS_DMA and SCSI_DMA.
>> I don't think so.  SCSI selects SCSI_DMA, it doesn't depend on it.
> 
> "A selects B" == "A depends on B, but please don't hide A when B is off
> and silently switch B on when A is switched on".
> 
> config SCSI
> 	tristate "SCSI device support"
> 	depends on BLOCK
> 	select SCSI_DMA if HAS_DMA
> 
> So, SCSI doesn't actually need SCSI_DMA per se, but it apparently needs
> it whenever HAS_DMA != n.

In fact, only a number of SCSI low-level drivers need SCSI_DMA.  But
libata and usb-storage are currently not among those drivers.  For them
it's currently harmless if SCSI_DMA is off.

SCSI_DMA only includes the symbols scsi_dma_map() and scsi_dma_unmap()
into the scsi core.  libata and usb-storage don't call these.
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
