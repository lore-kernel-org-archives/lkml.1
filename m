Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbXEPFWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbXEPFWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbXEPFWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:22:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53458 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760131AbXEPFWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:22:04 -0400
Message-ID: <464A94F9.5030300@garzik.org>
Date: Wed, 16 May 2007 01:22:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: fix shutdown warning message printing
References: <46487F9A.1080309@gmail.com>
In-Reply-To: <46487F9A.1080309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Unlocking ap->lock and ssleeping don't work because SCSI commands can
> be issued from completion path without context.  Reimplement delayed
> completion by allowing translation functions to override
> qc->scsidone(), storing the original completion function to
> scmd->scsi_done() and overriding qc->scsidone() with a function which
> schedules delayed invocation of scmd->scsi_done().
> 
> This isn't pretty at all but all the ugly parts are thankfully
> contained in the stop translation path where the compat feature is
> implemented.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

applied to #upstream-fixes


