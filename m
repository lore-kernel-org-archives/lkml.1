Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab0BJWN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:13:58 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34737 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639Ab0BJWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:13:56 -0500
Subject: Re: linux-next: build warning after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       Sarang Radke <sarang.radke@qlogic.com>
In-Reply-To: <20100210165133.0dd46452.sfr@canb.auug.org.au>
References: <20100210165133.0dd46452.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 17:13:51 -0500
Message-ID: <1265840031.2769.571.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 16:51 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the percpu tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> drivers/scsi/qla2xxx/qla_attr.c: In function 'qla2x00_process_vendor_specific':
> drivers/scsi/qla2xxx/qla_attr.c:2150: warning: 'req_data' may be used uninitialized in this function
> drivers/scsi/qla2xxx/qla_attr.c:2152: warning: 'req_data_len' may be used uninitialized in this function
> 
> If the first "goto done_unmap_sg;" in this function is followed, the
> req_data will be tested even though it has not been assigned to yet and
> if it is non zero, it and req_data_len will be passed to
> dma_free_coherent() while still uninitialised.
> 
> Introduced by commit 9a069e196767d7b87184fd8d8211d22bb5b9c0b8 ("[SCSI]
> qla2xxx: Add BSG support for FC ELS/CT passthrough and vendor commands").
> 
> The compiler also produces these:
> 
> drivers/scsi/qla2xxx/qla_attr.c:2144: warning: 'command_sent' may be used uninitialized in this function
> drivers/scsi/qla2xxx/qla_attr.c:2146: warning: 'type' may be used uninitialized in this function
> 
> but I can't easily tell if they are false positives.

They seem to be false positives.  The unconditional initialisation is on
line 2191, and there's no use before then that I can find ... I also
don't see this error on my builds, so it looks like a toolchain issue.

James


