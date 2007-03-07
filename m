Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbXCGFKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbXCGFKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 00:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965136AbXCGFKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 00:10:40 -0500
Received: from gw.goop.org ([64.81.55.164]:45753 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826AbXCGFKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 00:10:40 -0500
Message-ID: <45EE494D.6090403@goop.org>
Date: Tue, 06 Mar 2007 21:10:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com> <1173228544.24738.514.camel@localhost.localdomain>
In-Reply-To: <1173228544.24738.514.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Ooops. I completely forgot, that you get the absolute expiry time
> already in ktime_t format (nanoseconds) when dev->set_next_event() is
> called.
>
> 	dev->next_event = expires;
>
> is done right before the call. 
>
> So it's already there for free.
>   

OK, but a trap for young players (ie, me): the absolute time is in ns
since kernel boot, but the hypervisor wants an absolute time in ns since
system boot.  Everything works reasonably well for the first guest
started early, so be sure to take a snapshot of hypervisor time early in
order to get the correction...

    J

