Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXDJWVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXDJWVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030400AbXDJWVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:21:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60836 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401AbXDJWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:21:05 -0400
Subject: Re: 2.6.21-rc6-mm1 aacraid not finding device
From: Steve Fox <drfickle@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mark_salyzyn@adaptec.com,
       markh@linux-foundation.org, James.Bottomley@SteelEye.com,
       linux-scsi@vger.kernel.org
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 17:21:01 -0500
Message-Id: <1176243661.5949.59.camel@drfickle.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 14:35 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/

Since 2.6.21-rc5-mm1, one of the test.kernel.org machines (elm3b239) has
not been able to boot because it cannot find the SCSI device. You can
view http://test.kernel.org/abat/82623/debug/console.log for the latest
boot log (rc6-mm1).

I tracked this down to the git-scsi-misc patch in the -mm tree and then
bisected the scsi-misc git tree until I reached the commit below from
Mark Salyzyn:

fe76df4235986cfacc2d3b71cef7c42bc1a6dd6c

[SCSI] aacraid: Fix blocking issue with container probing function (cast update)

This is a pretty big patch, so hopefully Mark can take a look at it.
lspci shows

01:02.0 RAID bus controller: Adaptec AAC-RAID (rev 02)
0f:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)
1d:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)
2b:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)

on 2.6.21-rc6. Let me know if I can provide more details.

-- 

Steve Fox
IBM Linux Technology Center

