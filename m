Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZF1Oow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZF1Oow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZF1Oon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:44:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36377 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZF1Oom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:44:42 -0400
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: James Smart <James.Smart@Emulex.Com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Olaf Hering <olh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Benny Halevy <bhalevy@panasas.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <4A477F00.70305@emulex.com>
References: <1246122359.32198.7.camel@hpdv5.satnam>
	 <4A47222B.5020702@panasas.com>  <4A477F00.70305@emulex.com>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 09:44:42 -0500
Message-Id: <1246200282.4190.13.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 10:32 -0400, James Smart wrote:
> Sorry folks --  the nuance of the clibrary having it's own version of a 
> kernel header for distros was completely unknown to me.
> 
> Christoph mentioned this to me last week, with the recommendation to 
> back out the patch and move the other headers that were exprted into 
> include/linux - thus nothing in include/scsi gets export.  No Problem. 
> and I'll do so shortly.

Actually, I'm not sure that's the best way forwards ... the idea of
include/scsi is to group all the SCSI headers together; having to put
them in include/linux if they need to be exported defeats that purpose
slightly.

I think the first point of business might be to find out why (or even
if) glibc still wants its own SCSI headers.  After all, we now have
quite an anomaly: if you use the old SG_IO ioctl, glibc supplies the
header in include/scsi/sg.h; if you use the new bsg SG_IO then we supply
it in include/linux/bsg.h

> How does a lowly contributor track these kind of nuances ?

If the creator of the kernel header exports missed this problem for a
year, I think it's safe to assume you don't lose brownie points for not
spotting it either.

James


