Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXJaQel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXJaQel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbXJaQec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:34:32 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:54161 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbXJaQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:34:31 -0400
Message-ID: <4728AE87.10004@gentoo.org>
Date: Wed, 31 Oct 2007 16:34:15 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu> <47276DCA.1000808@gentoo.org> <20071030190153.373c9347@the-village.bc.nu> <47278439.4030801@gentoo.org> <20071031114958.210bd7cc@the-village.bc.nu> <20071031115754.GK5059@kernel.dk> <472872F6.70802@garzik.org> <20071031122639.GN5059@kernel.dk> <4728A7D4.8050008@garzik.org>
In-Reply-To: <4728A7D4.8050008@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jens Axboe wrote:
>> Right, that's of course problematic... There has to be a way to recover
>> that situation though, or you can't export any user command issue
>> facility.
> 
> You cannot hope to handle all possible effects arising from an app 
> providing an invalid sg header / cdb.

Is it "invalid" though? As a SCSI command, it seems perfectly valid to 
ask for less data than the total amount the drive could possibly send.

It's only when we have to translate it to an ATA command in libata that 
it becomes invalid there, right?

Are you saying that we should limit the SG_IO commands to only ones that 
are valid both as SCSI *and* as their ATA translations? Would that be 
for all SCSI devices, or just ones that libata backs?

Daniel
