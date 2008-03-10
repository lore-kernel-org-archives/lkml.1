Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYCJQco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYCJQco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYCJQcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:32:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYCJQce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:32:34 -0400
Message-ID: <47D56233.10801@redhat.com>
Date: Mon, 10 Mar 2008 12:30:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on
 pata_ali
References: <200803082246.47987.rjw@sisk.pl>
In-Reply-To: <200803082246.47987.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2008 04:46 PM, Rafael J. Wysocki wrote:
> Hi,
> 
> On one of my test boxes I'm unable to do just about anything with audio CDs
> using the current -git (2.6.24 is fine in that respect on the same box).
> 
> When an audio CD is inserted into the drive, I get the following errors in
> dmesg and nothing more happens (quite obviously):
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd a0/01:00:00:10:00/00:00:00:00:00/a0 tag 0 dma 16400 in
>          cdb 42 02 40 01 00 00 00 00  10 00 00 00 00 00 00 00
>          res 40/00:00:00:18:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for UDMA/33
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd a0/01:00:00:10:00/00:00:00:00:00/a0 tag 0 dma 16400 in
>          cdb 42 02 40 01 00 00 00 00  10 00 00 00 00 00 00 00
>          res 40/00:00:00:18:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: port is slow to respond, please be patient (Status 0x80)
> ata1: device not ready (errno=-16), forcing hardreset
> ata1: soft resetting link
> ata1.00: qc timeout (cmd 0xa1)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: revalidation failed (errno=-5)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: port is slow to respond, please be patient (Status 0x80)
> ata1: device not ready (errno=-16), forcing hardreset
> ata1: soft resetting link
> ata1.00: qc timeout (cmd 0xa1)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: revalidation failed (errno=-5)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: port is slow to respond, please be patient (Status 0x80)
> ata1: device not ready (errno=-16), forcing hardreset
> ata1: soft resetting link
> ata1.00: qc timeout (cmd 0xa1)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: revalidation failed (errno=-5)
> ata1.00: disabled
> 

We still have DMA totally disabled on pata_ali in Fedora.
