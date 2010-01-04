Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506Ab0ADAly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0ADAly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941Ab0ADAlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:41:53 -0500
Received: from bar.sig21.net ([80.81.252.164]:56105 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0ADAlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:41:52 -0500
Date: Mon, 4 Jan 2010 01:41:47 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Tejun Heo <tj@kernel.org>
Cc: Hans Werner <HWerner4@gmx.de>, linux-kernel@vger.kernel.org, trenn@suse.de,
       mmalygin@ked.de, hancockrwd@gmail.com, greg@kroah.com
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix
 FailSafe issue?
Message-ID: <20100104004147.GA19558@sig21.net>
References: <20091230120428.5780@gmx.net>
 <20100103221142.GA16783@sig21.net>
 <4B41216F.4070906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B41216F.4070906@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.770,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 07:59:59AM +0900, Tejun Heo wrote:
> On 01/04/2010 07:11 AM, Johannes Stezenbach wrote:
> > 
> > FWIW, I just tested a current git kernel (v2.6.33-rc2-268-g45d28b0)
> > with Tejun's patch applied on my N130.  The ATA exception and hang is
> > indeed gone, just "ata1: clearing spurious IRQ" is logged.
> > 
> > I've see Tejun's comment in
> > http://bugzilla.kernel.org/show_bug.cgi?id=14314
> > and I would like to add that the ATA irq is not shared.
> > 
> >  14:      43885          0   IO-APIC-edge      ata_piix
> >  15:          0          0   IO-APIC-edge      ata_piix
> 
> Can you please post that on bug#14314?  If the IRQ line indeed wasn't
> shared, it might mean that the controller raised the IRQ line before
> getting its internal state in order and the IRQ checking sequence
> cleared the external IRQ status while leaving the internal pending bit
> intact, which I've never heard of on piix and don't think is possible.
> Hmmmm... given that the problem was dependent on BIOS on the other
> model (is it the N130?), maybe the BIOS is doing something funny.  :-(
> Anyways, please post full output of "cat /proc/interrupts" at the bz.

I've updated bug#14314.  It is certainly a BIOS issue, but the
"spurious IRQ" check deals way better with it than the previous
30sec hang waiting for timeout.  IMHO the patch should be merged
into mainline asap.  Or do you think it has any downside?


Thanks
Johannes
