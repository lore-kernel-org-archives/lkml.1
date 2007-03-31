Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXCaQPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXCaQPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbXCaQPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:15:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54941 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbXCaQPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:15:30 -0400
Date: Sat, 31 Mar 2007 09:09:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Maxim Levitsky <maximlevitsky@gmail.com>,
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
Subject: Re: [PATCH v2] Add suspend/resume for HPET
In-Reply-To: <1175356272.28263.27.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703310908160.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> 
 <460BBD1B.4040308@ru.mvista.com>  <200703291531.18253.maximlevitsky@gmail.com>
  <200703291546.48996.maximlevitsky@gmail.com> <1175356272.28263.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Mar 2007, Thomas Gleixner wrote:
> 
> While I agree in principle with the patch, I'm a bit uncomfortable. The
> sys device suspend / resume ordering is not guaranteed and relies on the
> registering order.

Well, this is why we probably should try to get away from the "system 
device" issue, exactly because system devices are totally outside the 
normal ordering and only have a random linear order.

If the clocksources were actually in the device tree, you'd get all the 
normal guarantees about hierarchical ordering..

		Linus
