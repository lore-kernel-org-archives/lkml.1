Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYJAPMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYJAPMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYJAPMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:12:35 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:7495 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYJAPMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:12:34 -0400
Date: Wed, 1 Oct 2008 10:12:33 -0500
From: scameron@beardog.cca.cpqcorp.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, axboe@kernel.dk
Subject: Re: [patch] cciss: Fix cciss SCSI rescan code to better notice device changes.
Message-ID: <20081001151233.GK25762@beardog.cca.cpqcorp.net>
References: <20080918200744.GA24032@beardog.cca.cpqcorp.net> <20080919171931.e7e7b731.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919171931.e7e7b731.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 05:19:31PM -0700, Andrew Morton wrote:
> On Thu, 18 Sep 2008 15:07:44 -0500
[...] 
> y'know, it would be a lot simpler to just do
> 
> 	*sd = *device;
> 
> a few lines up, before assigning sd->bus/target/lun.
> 
> Putting these:
> 
> @@ -66,6 +66,10 @@ struct cciss_scsi_dev_t {
>  	int devtype;
>  	int bus, target, lun;		/* as presented to the OS */
>  	unsigned char scsi3addr[8];	/* as presented to the HW */
> +	unsigned char device_id[16];	/* from inquiry pg. 0x83 */
> +	unsigned char vendor[8];	/* bytes 8-15 of inquiry data */
> +	unsigned char model[16];	/* bytes 16-31 of inquiry data */
> +	unsigned char revision[4];	/* bytes 32-35 of inquiry data */
>  };
> 
> into a separate nested structure might make that neater still.
> 
[... and a bunch of other helpful comments. ]


Sorry for the slow reply, I've been on vacation.

Thanks for looking over my patch.  I'll try to make a 
patch to incorporate your suggestions.

> didn't cciss_scsi_add_entry() just do that?  I didn't look too closely,
> so maybe it didn't, and we're taking two copies for some reason.
> Please double-chec

I think you're right about that, good catch.

-- steve

