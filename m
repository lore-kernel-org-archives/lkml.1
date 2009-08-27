Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZH0J2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZH0J2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZH0J2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:28:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:52578 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZH0J2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:28:09 -0400
Subject: Re: Extending virtio_console to support multiple ports
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Amit Shah <amit.shah@redhat.com>, qemu-devel@nongnu.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, miltonm@bga.com,
       linuxppc-dev@ozlabs.org, brueckner@linux.vnet.ibm.com
In-Reply-To: <20090827100809.5f0aa0a7@linux.intel.com>
References: <1251181044-3696-1-git-send-email-amit.shah@redhat.com>
	 <20090826112718.GA11117@amit-x200.redhat.com>
	 <20090826154552.GA31910@amit-x200.redhat.com>
	 <1251346023.20467.21.camel@pasglop>
	 <20090827100809.5f0aa0a7@linux.intel.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 19:27:23 +1000
Message-Id: <1251365243.20467.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 10:08 +0100, Alan Cox wrote:
> >  - Then, are we certain that there's no case where the tty layer will
> > call us with some lock held or in an atomic context ? To be honest,
> > I've totally lost track of the locking rules in tty land lately so it
> > might well be ok, but something to verify.
> 
> Some of the less well behaved line disciplines do this and always have
> done.

That was also my understanding but heh, I though that maybe you may have
fixed all of that already :-)

So at this stage, I think the reasonably thing to do is to stick to the
spinlock, but we can try to make it a bit smarter, and we can definitely
attempt to fix the case Amit pointed out where we call resize without a
lock while it seems to expect it (though we also need to be careful
about re-entrancy I believe).

Cheers,
Ben.


