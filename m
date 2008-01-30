Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYA3VAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYA3VAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYA3VAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:00:22 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52601 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbYA3VAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:00:20 -0500
Subject: Re: [2.6 patch] scsi/qlogicpti.c section fixes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080130200336.GN29368@does.not.exist>
References: <20080130200336.GN29368@does.not.exist>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 15:00:16 -0600
Message-Id: <1201726817.3292.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 22:03 +0200, Adrian Bunk wrote:
> This patch fixes the following section mismatches:
> 
> <--  snip  -->
> 
> ...
> WARNING: drivers/scsi/qlogicpti.o(.devexit.text+0x8): Section mismatch in reference from the function qpti_sbus_remove() to the function .init.text:qpti_chain_del()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x56c): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_regs()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x580): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_register_irq()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x594): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_get_scsi_id()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x5b8): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_queues()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x780): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_chain_add()
> ...

OK, look, this is really getting out of hand.

__init is possibly justifiable with a few hundred k savings on boot.
__devinit and the rest are surely killable on the grounds they provide
little benefit for all the pain they cause.

all __exit seems to do is set us up for unreferenced pointers in
discarded sections, so could we kill that too?

James


