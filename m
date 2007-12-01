Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXLAX3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXLAX3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXLAX26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:28:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48305 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbXLAX25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:28:57 -0500
Message-ID: <4751EE36.6050506@garzik.org>
Date: Sat, 01 Dec 2007 18:28:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ata: ahci: Enclosure Management via LED rev2
References: <20071129121925.7d178915@appleyard> <20071130163443.2feabc5d@appleyard>
In-Reply-To: <20071130163443.2feabc5d@appleyard>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Enclosure Management via LED
> 
> This patch implements Enclosure Management via the LED protocol as specified
> in AHCI specification.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
> This revision makes the change to the comment requested by Mark Lord,
> fixes some bugs in the bit shifting for writing the new led state,
> and implements a show function so that led status can be read as
> well as written.

Overall looks pretty good, from a technical review perspective.

Two worries:

1) exporting ata_scsi_find_dev(), and assuming a scsi device is 
attached.  the latter can be fixed by a !NULL check (and should be), but 
its a bit of a layering violation since long term we want to make the 
SCSI simulator optional for all ATA devices.

2) vaguely related to #1, I'm not so sure the attributes should be 
implemented directly in ahci.  if this __or something like it__ appears 
on non-Intel hardware, the code should be somewhere more generic.


