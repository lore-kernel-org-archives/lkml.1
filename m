Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbZD3CT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbZD3CT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZD3CTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:19:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:34199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZD3CTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:19:48 -0400
Message-ID: <49F90ABE.4040607@kernel.org>
Date: Thu, 30 Apr 2009 11:19:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
 question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org>
In-Reply-To: <E1LzLgA-0004j6-9W@closure.thunk.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 02:19:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Theodore Ts'o wrote:
> [ 4563.614247] ata4.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/32)
> 
> which as near as I can tell is because ATA_FLAG_NCQ isn't set in struct
> ata_port->flag.  This looks like it should be set to ata_piix.c if the
> controller supports NCQ --- but ata_piix.c doesn't set ATA_FLAG_NCQ at
> all.  However, this web page:
> 
> 	http://www.intel.com/support/chipsets/imst/sb/CS-012304.htm
> 
> Seems to imply the 82801HBM/HEM SATA controller from the ICH8M/ICHM8-E
> supports AHCI and NCQ, and this is the controller which is in the X61s
> laptop.

The controller can be drive in two different modes - piix and ahci.
In piix mode, it behaves like good old IDE controller from 15 years
back and can't do NCQ.  Looks like your controller is in piix mode.

> So I wonder if it's safe to simply add ATA_FLAG_NCQ to ata_piix.c or
> not?  Can someone who's more familiar with Intel's ICH8 SATA controller
> comment on whether this would be a safe thing to do?

Oh... please don't that.  It won't work.  On ICHs, whether the
controller is put in piix or ahci mode is determined by the BIOS.
Most desktop BIOSen have option to put the controller in different
modes but most laptops don't seem to have such option.

Thanks.

-- 
tejun
