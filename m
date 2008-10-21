Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbYJUJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbYJUJfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYJUJfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:35:44 -0400
Received: from aun.it.uu.se ([130.238.12.36]:38808 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYJUJfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:35:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18685.41265.560866.890756@harpo.it.uu.se>
Date: Tue, 21 Oct 2008 11:30:25 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
In-Reply-To: <48FD9A90.8000205@gmail.com>
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
	<48EBFE9B.9070503@gmail.com>
	<18674.4081.839329.116533@harpo.it.uu.se>
	<48F2D9A8.1030502@gmail.com>
	<18683.50533.786782.474536@harpo.it.uu.se>
	<48FD580E.4080101@gmail.com>
	<18685.35653.125899.390135@harpo.it.uu.se>
	<48FD9A90.8000205@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo writes:
 > Hello,
 > 
 > Mikael Pettersson wrote:
 > > Tejun Heo writes:
 > >  > Hello, Mikael.
 > >  > I would put this into ->hardreset itself as the controller can also
 > >  > get out of sync with reality during reset.
 > > 
 > > The only thing I see going on between prereset and (hard/soft)reset
 > > is an optional freeze, so I don't see why moving the pdc_reset_port()
 > > into the beginning of hardreset() would make any difference.
 > > 
 > > sata_promise currently uses the ->hardreset and ->softreset inherited
 > > from ata_sff_port_ops, so it would need to override both to ensure that
 > > we always do pdc_reset_port() before libata does its thing. That's why
 > > I felt doing that in ->prereset would be the right solution.
 > 
 > Hmm.. reset sequence goes on like the following.
 > 
 >  1. prereset
 >  2. hardreset, if fail, retry
 >  3. follow-up softreset if requested, if fail, goto #2
 >  4. postreset, if successful
 > 
 > So, if some PHY event happens while the reset is waiting for device
 > readiness and makes the controller state go out of sync with the
 > drive.  ->prereset() will NOT be called for the following retry.

I see. Ok, then I'll forget about ->prereset and bind ->hardreset to
code which does pdc_reset_port() before invoking sata_sff_hardreset().

Thanks for your input.

/Mikael
