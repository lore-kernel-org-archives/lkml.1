Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXAaBlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXAaBlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXAaBlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:41:45 -0500
Received: from rtr.ca ([64.26.128.89]:2462 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbXAaBlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:41:44 -0500
Message-ID: <45BFF3D6.9050605@rtr.ca>
Date: Tue, 30 Jan 2007 20:41:42 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: "Eric D. Mudama" <edmudama@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>
In-Reply-To: <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric D. Mudama wrote:
>
> Actually, it's possibly worse, since each failure in libata will 
> generate 3-4 retries.  With existing ATA error recovery in the drives, 
> that's about 3 seconds per retry on average, or 12 seconds per failure.  
> Multiply that by the number of blocks past the error to complete the 
> request..

It really beats the alternative of a forced reboot
due to, say, superblock I/O failing because it happened
to get merged with an unrelated I/O which then failed..
Etc..

Definitely an improvement.

The number of retries is an entirely separate issue.
If we really care about it, then we should fix SD_MAX_RETRIES.

The current value of 5 is *way* too high.  It should be zero or one.

Cheers
