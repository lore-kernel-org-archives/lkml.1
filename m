Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYHaB7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYHaB7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 21:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbYHaB7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 21:59:08 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53587 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbYHaB7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 21:59:07 -0400
Subject: Re: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <48B9B588.7060709@simon.arlott.org.uk>
References: <48B9546B.4010004@simon.arlott.org.uk>
	 <1220117091.3615.3.camel@localhost.localdomain>
	 <20080830174516.GD1239@parisc-linux.org>
	 <48B9B552.8060406@simon.arlott.org.uk>
	 <48B9B588.7060709@simon.arlott.org.uk>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 20:59:07 -0500
Message-Id: <1220147947.3615.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-30 at 22:03 +0100, Simon Arlott wrote:
> The capacity printk'd in bytes is divided by 1000000,
> whereas 1048576 would be more consistent with the rest
> of the OS and disk-related utilities ('df' etc.).
> 
> This change replaces the (sz - (sz/625 - 974))/1950
> calculation with a simple right shift to output with
> five significant digits the capacity in KB, MB, GB, TB,
> PB, or EB. Anything beyond this becomes too large...

Well, still needs to be dividing by 1000 not 1024 for SCSI and ATA.
However, I'm afraid it needs to be a bit more sophisticated:  for
instance, under these calculations, a 1.75TB disk will show up as 1TB.
Thus, I think we need to print the capacity to 3 significant figures to
cope with this case.

James


