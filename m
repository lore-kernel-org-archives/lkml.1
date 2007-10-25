Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbXJYE12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbXJYE12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbXJYE1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:27:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbXJYE1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:27:17 -0400
Date: Wed, 24 Oct 2007 21:27:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] [SCSI] ips: remove ips_ha members that duplicate
 struct pci_dev members
Message-Id: <20071024212710.ae6e5120.akpm@linux-foundation.org>
In-Reply-To: <20071024234827.74AD61F81A1@havoc.gtf.org>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>
	<20071024234827.74AD61F81A1@havoc.gtf.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 19:48:26 -0400 (EDT) Jeff Garzik <jeff@garzik.org> wrote:

>  drivers/scsi/ips.c |  178 ++++++++++++++++++++++++----------------------------

this driver seems a bit of a basket case :(


What's going on here?

		scb->dcdb.cmd_attribute =
		    ips_command_direction[scb->scsi_cmd->cmnd[0]];

        /* Allow a WRITE BUFFER Command to Have no Data */
        /* This is Used by Tape Flash Utilites          */
        if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0)) 
            scb->dcdb.cmd_attribute = 0;                  

		if (!(scb->dcdb.cmd_attribute & 0x3))
			scb->dcdb.transfer_length = 0;

		if (scb->data_len >= IPS_MAX_XFER) {

I hope that's just busted indentation and not a missing {} block.
