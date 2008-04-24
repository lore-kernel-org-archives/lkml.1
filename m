Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYDXQVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYDXQVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYDXQU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:20:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40753 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbYDXQU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:20:59 -0400
Message-ID: <4810B361.8000305@garzik.org>
Date: Thu, 24 Apr 2008 12:20:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
References: <20080422221733.GA16260@havoc.gtf.org>	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>	<480E6DE5.6010103@garzik.org>	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>	<480E796E.4070001@garzik.org>	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>	<20080423000529.GG28933@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>	<480F3ECC.1090809@keyaccess.nl>	<480FEC1B.6040102@garzik.org>	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>	<m1od7zkd2s.fsf@frodo.ebiederm.org>	<481066C1.1030805@garzik.org>	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>	<4810A9E6.1080201@garzik.org>	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org> <20080424163735.29ef21db@the-village.bc.nu>
In-Reply-To: <20080424163735.29ef21db@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Sparc32 had this and it was very ugly. However if you don't pass in the
> IRQ then people will store the irq value privately and things like
> request_irq can deal with numeric interrupts and the like as before while
> new interfaces for MSI can deal in MSI objects whatever they end up like.


Yes, and on a related note...

_Today_ drivers _already_ store the irq value privately, because they must:

Logic dictates they must do so because all other functions in the driver 
do not have an 'irq' argument, but do need to call things (free_irq, 
disable_irq) that take an irq number argument.

That is one of my key design objections to passing 'int' to an irq handler:

Every modern driver _must_ store the irq value anyway -- and typically 
this is done automatically in struct device or struct pci_dev resources, 
so the driver writer need not bother with storing it themselves.

	Jeff




