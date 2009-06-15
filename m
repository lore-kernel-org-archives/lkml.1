Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbZFOPMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbZFOPMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZFOPLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:11:51 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39629 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235AbZFOPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:11:50 -0400
Subject: Re: linux-next: scsi tree build failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20090615121716.c5bc0655.sfr@canb.auug.org.au>
References: <20090615121716.c5bc0655.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 10:11:47 -0500
Message-Id: <1245078707.3858.0.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 12:17 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> drivers/scsi/ps3rom.c: In function 'ps3rom_interrupt':
> drivers/scsi/ps3rom.c:302: error: implicit declaration of function 'ps3_system_bus_get_drvdata'
> drivers/scsi/ps3rom.c:302: warning: assignment makes pointer from integer without a cast
> drivers/scsi/ps3rom.c: In function 'ps3rom_probe':
> drivers/scsi/ps3rom.c:390: error: implicit declaration of function 'ps3_system_bus_set_drvdata'
> drivers/scsi/ps3rom.c: In function 'ps3rom_remove':
> drivers/scsi/ps3rom.c:421: warning: initialization makes pointer from integer without a cast
> 
> Caused by commit 4381bd58427116cd7689831998771ddd58078af9 ("[SCSI]
> ps3rom: Use ps3_system_bus_[gs]et_drvdata() instead of direct access").
> This is number 21 in a series and depends on number 19 which is not yet
> merged.  If you instead Ack this patch, Ben will merge it through the
> powerpc tree.
> 
> For today, I have used the scsi tree from next-20090612.

OK, dumped the offending patch, so it should be safe to take scsi-misc
again.

I'm so used to merging these type of conversions, I didn't check that it
was using a ps3 specific wrapper instead of a generic device one.

James


