Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYBQQDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYBQQDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYBQQDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:03:13 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42965 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYBQQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:03:10 -0500
Subject: Re: [PATCH] ieee1394: sbp2: fix rescan-scsi-bus
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <tkrat.e66f8acfe9d89925@s5r6.in-berlin.de>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
	 <tkrat.e66f8acfe9d89925@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 10:03:05 -0600
Message-Id: <1203264186.3082.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-17 at 14:57 +0100, Stefan Richter wrote:
> rescan-scsi-bus used to add SBP-2 targets which weren't there.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/ieee1394/sbp2.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/drivers/ieee1394/sbp2.c
> ===================================================================
> --- linux.orig/drivers/ieee1394/sbp2.c
> +++ linux/drivers/ieee1394/sbp2.c
> @@ -1974,6 +1974,9 @@ static int sbp2scsi_slave_alloc(struct s
>  {
>  	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
>  
> +	if (sdev->lun != 0 || sdev->id != lu->ud->id || sdev->channel != 0)
> +		return -ENODEV;
> +

It's hard to know what to say about this.  The infrastructure for
scanning did move to separate scanned (old parallel and a few other)
busses from hotplug ones (which is what sbp2 is).  You really need to
look at the scan_finished and user_scan callbacks.  Unfortunately the
latter is a transport class function and how all the modern busses (FC,
SAS and the like do this).

James


