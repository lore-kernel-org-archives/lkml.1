Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbXEQAvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbXEQAvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762490AbXEQAvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:51:01 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:34340 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761158AbXEQAu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:50:57 -0400
Date: Thu, 17 May 2007 09:50:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
Message-ID: <20070517005016.GA25935@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	garyhade@us.ibm.com
References: <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <20070511005217.GA23186@linux-sh.org> <464439C8.7090309@gmail.com> <20070512034928.GB29259@linux-sh.org> <20070516003002.GA18863@linux-sh.org> <464B3505.20004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B3505.20004@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 06:44:53PM +0200, Tejun Heo wrote:
> This patch is against the current libata-dev#upstream +
> pata_scc-fix-build-failure[1].
> 
>   [1] http://article.gmane.org/gmane.linux.kernel/528405
> 
> Paul, please verify this fixes your problem.  You can skip the
> pata_scc patch, it will cause pata_scc part to be rejected but doesn't
> matter.
> 
Yes, this does get iVDR detection working again. The only problem seems
to be that every now and then I end up with this:

scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
ata1: device not ready (errno=-19), forcing hardreset
ata1: COMRESET failed (errno=-19)
ata1: reset failed (errno=-19), retrying in 9 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)

So at least the drive detection works, but it would be nice not to
trigger this 9-second retry.
