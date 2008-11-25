Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYKYJVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYKYJVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKYJVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:21:18 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56630 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYKYJVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:21:17 -0500
Date: Tue, 25 Nov 2008 10:19:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [Patch][RFC] Supress Buffer I/O errors when SCSI REQ_QUIET flag set
Message-ID: <20081125091917.GU26308@kernel.dk>
References: <1227561983.6487.32.camel@keith-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227561983.6487.32.camel@keith-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24 2008, Keith Mannthey wrote:
> Allow the scsi request REQ_QUIET flag to be propagated to the buffer
> file system layer. The basic ideas is to pass the flag from the scsi
> request to the bio (block IO) and then to the buffer layer.  The buffer
> layer can then suppress needless printks. 
> 
> This patch declutters the kernel log by removed the 40-50 (per lun)
> buffer io error messages seen during a boot in my multipath setup . It
> is a good chance any real errors will be missed in the "noise" it the
> logs without this patch. 
> 
> During boot I see blocks of messages like 
> "
> __ratelimit: 211 callbacks suppressed
> Buffer I/O error on device sdm, logical block 5242879
> Buffer I/O error on device sdm, logical block 5242879
> Buffer I/O error on device sdm, logical block 5242847
> Buffer I/O error on device sdm, logical block 1
> Buffer I/O error on device sdm, logical block 5242878
> Buffer I/O error on device sdm, logical block 5242879
> Buffer I/O error on device sdm, logical block 5242879
> Buffer I/O error on device sdm, logical block 5242879
> Buffer I/O error on device sdm, logical block 5242879
> Buffer I/O error on device sdm, logical block 5242872
> "
> in my logs. 
> 
> My disk environment is multipath fiber channel using the SCSI_DH_RDAC
> code and multipathd.  This topology includes an "active" and "ghost"
> path for each lun. IO's to the "ghost" path will never complete and the
> SCSI layer, via the scsi device handler rdac code, quick returns the IOs
> to theses paths and sets the REQ_QUIET scsi flag to suppress the scsi
> layer messages. 
> 
>  I am wanting to extend the QUIET behavior to include the buffer file
> system layer to deal with these errors as well. I have been running this
> patch for a while now on several boxes without issue.  A few runs of
> bonnie++ show no noticeable difference in performance in my setup. 
> 
> Thanks for John Stultz for the quiet_error finalization. 

Looks good to me. I'll merge it up for 2.6.29.

-- 
Jens Axboe

