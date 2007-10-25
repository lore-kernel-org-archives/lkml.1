Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbXJYF6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbXJYF6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXJYF6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:58:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54141 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbXJYF6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:58:13 -0400
Message-ID: <47203073.7090809@garzik.org>
Date: Thu, 25 Oct 2007 01:58:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: Enable enclosure management via LED (resend)
References: <20071024155845.5129d6a4.kristen.c.accardi@intel.com>
In-Reply-To: <20071024155845.5129d6a4.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Enable enclosure management via LED
> 
> As described in the AHCI spec, some AHCI controllers may support 
> Enclosure management via a variety of protocols.  This patch
> adds support for the LED message type that is specified in 
> AHCI 1.1 and higher.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> ---
>  drivers/ata/ahci.c        |  153 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/ata/libata-scsi.c |    5 -
>  include/linux/libata.h    |    3 
>  3 files changed, 157 insertions(+), 4 deletions(-)

Comments:

1) it seems a bit questionable that the attributes are globally 
writeable, even by unpriveleged heathens?

2) ahci_led_locate_store() and ahci_led_fault()_store are the same, save 
for a single constant

3) Don't document ahci_em_messages values (like SGPIO) which are not 
actually supported in the code.  Feel free to put these in a comment to 
make sure others follow your lead, however

4) ahci_transmit_led_message() is issued completely without any locking. 
   that does not look safe in the face of libata-eh doing a reset?

5) please run through scripts/checkpatch in 2.6.24-rc1, there are 
several "use tabs not spaces" type errors and some other minor style nits

6) ATA_FLAG_EM is added but never used

7) Is it valid to check capabilities bit 6 (EMS) on AHCI 1.0?  I would 
tend to shy away from assuming that all silicon gives us sane 'reserved' 
bits :)

8) when is this actually used?  do you have a sample user in userspace? 
  does a userspace daemon watch disk activity and manage LEDs somehow? 
I'm a bit cloudy on the usage need of this.

9) overall, sans the above comments, the overall goal seems OK to me, 
and the patch seems pretty good.


