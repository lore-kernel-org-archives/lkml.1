Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYAFRvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYAFRvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYAFRvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:51:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59850 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYAFRva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:51:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <478114F3.6020804@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 18:50:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
References: <200801051546.SAA08947@raad.intranet> <200801060803.27101.a1426z@gawab.com> <4780E814.4050405@s5r6.in-berlin.de> <200801062007.31516.a1426z@gawab.com>
In-Reply-To: <200801062007.31516.a1426z@gawab.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Stefan Richter wrote:
>> Al Boldi wrote:
>>>   	menuconfig USB_STORAGE
>>>   	tristate "USB Mass Storage support"
>>> -	depends on USB && SCSI
>>> +	depends on USB && BLOCK
>>> +	select SCSI
>> Still wrong. SCSI also needs HAS_DMA and SCSI_DMA.
> 
> I don't think so.  SCSI selects SCSI_DMA, it doesn't depend on it.

"A selects B" == "A depends on B, but please don't hide A when B is off
and silently switch B on when A is switched on".

config SCSI
	tristate "SCSI device support"
	depends on BLOCK
	select SCSI_DMA if HAS_DMA

So, SCSI doesn't actually need SCSI_DMA per se, but it apparently needs
it whenever HAS_DMA != n.

> So it's safe to select SCSI here, as libata does it the same way.

Sam, does kconfig recursively follow select statements and switch on
options which are select'ed by select'ed options?  I suppose it doesn't.

Maybe this would be better:

 config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
-	select SCSI_DMA if HAS_DMA

 config SCSI_DMA
 	bool
-	default n
+	default y if SCSI && HAS_DMA

-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
