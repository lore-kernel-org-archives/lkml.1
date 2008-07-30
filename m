Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYG3VMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYG3VMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbYG3VMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:12:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbYG3VMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:12:05 -0400
Date: Wed, 30 Jul 2008 15:09:53 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Matt Frost <artusemrys@sbcglobal.net>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Frost <artusemrys@yahoo.com>, zaitcev@redhat.com
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
Message-Id: <20080730150953.771b1345.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0807301656030.2322-100000@iolanthe.rowland.org>
References: <4890C5EC.70305@torque.net>
	<Pine.LNX.4.44L0.0807301656030.2322-100000@iolanthe.rowland.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.13.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 17:00:10 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:

> +++ 2.6.26/drivers/usb/storage/transport.c
> @@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
> +		/* Heuristically detect devices that generate bogus residues
> +		 * by seeing what happens with INQUIRY and READ CAPACITY
> +		 * commands.
> +		 */
> +		if (bcs->Status == US_BULK_STAT_OK &&
> +				scsi_get_resid(srb) == 0 &&
> +					((srb->cmnd[0] == INQUIRY &&
> +						transfer_length == 36) ||
> +					(srb->cmnd[0] == READ_CAPACITY &&
> +						transfer_length == 8))) {
> +			us->flags |= US_FL_IGNORE_RESIDUE;

Why do you do this for INQUIRY and READ_CAPACITY only?
Why not do it for any command?

-- Pete
