Return-Path: <linux-kernel-owner+w=401wt.eu-S1764460AbXJQOct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764460AbXJQOct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbXJQOcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:32:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60834 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXJQOcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:32:42 -0400
Date: Wed, 17 Oct 2007 15:32:40 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] fix not-and/or errors
Message-ID: <20071017143240.GH8181@ftp.linux.org.uk>
References: <47161243.6060007@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47161243.6060007@tiscali.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 03:46:43PM +0200, Roel Kluin wrote:
> +++ b/drivers/misc/asus-laptop.c
> @@ -322,7 +322,7 @@ static void write_status(acpi_handle handle, int out, int mask)
>  
>  	switch (mask) {
>  	case MLED_ON:
> -		out = !out & 0x1;
> +		out = !(out & 0x1);

Not sure if that's what had been intended.

> @@ -2882,7 +2882,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
>  			    !(STp->use_pf & PF_TESTED)) {
>  				/* Try the other possible state of Page Format if not
>  				   already tried */
> -				STp->use_pf = !STp->use_pf | PF_TESTED;
> +				STp->use_pf = !(STp->use_pf | PF_TESTED);

Wrong.  This code, ugly as it is, happens to be correct.  Replacement
isn't.  I would rewrite it as ^= PF_TESTED | USE_PF; /* remove USE_PF, set *
						      * PF_TESTED */

The rest is covered by Alexey's patch and one I'd posted as followup.
