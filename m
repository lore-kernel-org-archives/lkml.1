Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbXCaQdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbXCaQdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXCaQdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:33:23 -0400
Received: from www.osadl.org ([213.239.205.134]:37348 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752929AbXCaQdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:33:21 -0400
Subject: Re: [PATCH v2] Add suspend/resume for HPET
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
In-Reply-To: <Pine.LNX.4.64.0703310908160.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <460BBD1B.4040308@ru.mvista.com>
	 <200703291531.18253.maximlevitsky@gmail.com>
	 <200703291546.48996.maximlevitsky@gmail.com>
	 <1175356272.28263.27.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703310908160.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 18:33:20 +0200
Message-Id: <1175358800.28263.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 09:09 -0700, Linus Torvalds wrote:
> 
> On Sat, 31 Mar 2007, Thomas Gleixner wrote:
> > 
> > While I agree in principle with the patch, I'm a bit uncomfortable. The
> > sys device suspend / resume ordering is not guaranteed and relies on the
> > registering order.
> 
> Well, this is why we probably should try to get away from the "system 
> device" issue, exactly because system devices are totally outside the 
> normal ordering and only have a random linear order.
> 
> If the clocksources were actually in the device tree, you'd get all the 
> normal guarantees about hierarchical ordering..

Right, but clock - sources/events need to be extremly late suspended and
early resumed. How can we ensure this ?

	tglx


