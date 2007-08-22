Return-Path: <linux-kernel-owner+w=401wt.eu-S1764167AbXHVUwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764167AbXHVUwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763542AbXHVUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:51:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:62232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763556AbXHVUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:51:54 -0400
Subject: Re: [BUG] 2.6.23-rc3-mm1 - kernel BUG at net/core/skbuff.c:95!
From: Kay Sievers <kay.sievers@vrfy.org>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <46CC88B3.6080000@linux.vnet.ibm.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <46CC33EC.1040803@linux.vnet.ibm.com>
	 <20070822085002.8a116f72.akpm@linux-foundation.org>
	 <1187805493.5303.11.camel@lov.localdomain>
	 <46CC88B3.6080000@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 22:55:49 +0200
Message-Id: <1187816149.5303.44.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+fGUlXmxUXs4S+jzZic57sx0H+xd95OyV7g5R
 gnan5Uj11//XC8OXMZlTfLIBijb0GuBpM7fKUhUh5NW6YGN/q1
 YwAf5Zhk/DCSOdyzyO/XgRiciLE9WPI
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 00:34 +0530, Balbir Singh wrote:
> Kay Sievers wrote:
> >> gargh, sorry, that's probably due to my screwed up attempt to fix Kay's
> >> screwed up
> >> gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
> >>
> >> Kay sent an update patch but it didn't arrive in time.
> >>
> >> Greg, if you haven't yet merged that, please do so asap?
> >>
> >> So what _should_ this:
> >>
> >> --- a/arch/powerpc/kernel/vio.c~fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
> >> +++ a/arch/powerpc/kernel/vio.c
> >> @@ -373,7 +373,7 @@ static int vio_hotplug(struct device *de
> >>  	dn = dev->archdata.of_node;
> >>  	if (!dn)
> >>  		return -ENODEV;
> >> -	cp = of_get_property(dn, "compatible", &length);
> >> +	cp = of_get_property(dn, "compatible", &env->buflen);
> >>  	if (!cp)
> >>  		return -ENODEV;
> >>  
> >> _
> >>
> >> have done?
> > 
> > Does replacing "&length" with "NULL" work? That's what's in the updated
> > patch.

> replacing &length with NULL does not work for me. I get a message saying that
> init terminated with signal 7.

Hi Balbir,
ugh, I can't see what's going wrong here.

Care to just "return 0" for the whole function, and try again? Just to
rule out that this is the cause of the problem.

Thanks,
Kay

