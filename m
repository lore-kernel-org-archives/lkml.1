Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbXENPpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbXENPpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXENPpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:45:11 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:39160 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbXENPpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:45:09 -0400
Subject: Re: [PATCH] libata: fix shutdown warning message printing
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46487F9A.1080309@gmail.com>
References: <46487F9A.1080309@gmail.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 10:45:02 -0500
Message-Id: <1179157502.3703.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 17:26 +0200, Tejun Heo wrote:
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

Heh, very clever, but a bit of  a hack (however, no better way I can see
to do it given the layering constraints).

Acked-by: James Bottomley <James.Bottomley@SteelEye.com>

James


