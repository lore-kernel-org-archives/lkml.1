Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0BJWQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:16:21 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34747 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176Ab0BJWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:16:19 -0500
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Smart <james.smart@emulex.com>
In-Reply-To: <20100210123337.7a715aa0.sfr@canb.auug.org.au>
References: <20100210123337.7a715aa0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 17:16:16 -0500
Message-ID: <1265840176.2769.576.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 12:33 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/lpfc/lpfc_bsg.c: In function 'lpfc_bsg_diag_mode':
> drivers/scsi/lpfc/lpfc_bsg.c:1496: error: implicit declaration of function 'msleep'
> 
> Caused by commit 3b5dd52aaffd291edea9f939ed46a960b240bb45 ("[SCSI] lpfc
> 8.3.8: (BSG4) Add new vendor specific BSG Commands").
> 
> Missing include of linux/delay.h?

Looks to be exactly the problem.  delay.h gets pulled into some of the
generic headers on x86, but not on ppc.

Sorry, my powerstation isn't working (orange warning light) and I can't
seem to get anyone to repair it, so I can't build for ppc anymore (which
is why this didn't get spotted on commit).

James


