Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXIOOMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXIOOMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbXIOOMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:12:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40680 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXIOOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:12:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EBE821.2080300@s5r6.in-berlin.de>
Date: Sat, 15 Sep 2007 16:11:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
       James Bottomley <james.bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
References: <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <20070915125055.GQ3563@stusta.de> <46EBDC06.3030202@s5r6.in-berlin.de> <20070915135314.GS3563@stusta.de>
In-Reply-To: <20070915135314.GS3563@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Sep 15, 2007 at 03:20:06PM +0200, Stefan Richter wrote:
>> It still doesn't entirely clarify whether users need sd, sr, st, and
>> whether thy need sd for the disk with root filesystem.
> 
> If you want to do it in a really perfect way, help texts aren't the 
> solution. You'll have to make the options like CONFIG_BLK_DEV_SR no 
> longer be user visible and select'ed through dummy options like e.g.:
...
> 	tristate "USB Mass Storage hard disk support"
> 	depends on USB_STORAGE
> 	select BLK_DEV_SD
...
>         tristate "USB Mass Storage CD/DVD support"
>         depends on USB_STORAGE
> 	select BLK_DEV_SR
...

Perfect is in the eye of the beholder.  You would consequently have to
add such options into all menus which contain scsi low-level providers.

Also, one more question on whether CONFIG_SCSI ought to be 'select'ed:
Where do scsi-core options like CONFIG_SCSI_CONSTANTS go?
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
