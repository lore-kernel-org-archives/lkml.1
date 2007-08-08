Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbXHHOMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbXHHOMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934661AbXHHOLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:11:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:65171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934664AbXHHOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:11:53 -0400
Subject: Re: Error message from device_rename in drivers/base/core.c
From: Kay Sievers <kay.sievers@vrfy.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <46B9CC44.8000207@lwfinger.net>
References: <46B943D3.9020207@lwfinger.net>
	 <20070807.213724.27783161.davem@davemloft.net>
	 <20070808113359.71e77f49@gondolin.boeblingen.de.ibm.com>
	 <46B9B5C6.2070100@lwfinger.net>
	 <3ae72650708080646k4279e48boc3a77d6454c8d72d@mail.gmail.com>
	 <46B9CC44.8000207@lwfinger.net>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 16:14:51 +0200
Message-Id: <1186582491.2573.17.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/1/8rQx7kc8+gjeqa3B+ptTS6oIuvcVnZWWMu
 hRImPqI5aN+GgJ3WS8ucNLVYiEF+9mHrwf7hoOiqPNXNhNjh8E
 L6MM/6/PL44ASYvigS7Gz4wUpgEI94p
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-08-08 at 08:59 -0500, Larry Finger wrote:
> Kay Sievers wrote:
> > On 8/8/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> >> I agree with you, but you and David can fight it out. While finding out where to ask/complain about
> >> udev, I had a private communication with GregKH. He thinks that a patch to fix this has already been
> >> pushed through Linus. As Linville's wireless-dev tree is a little behind, I'm waiting to see if it
> >> gets fixed here by 2.6.23-rc3. If not, I'll talk to the udev/hotplug folks.
> > 
> > Hmm, I can not immediately see how udev could request the renaming to
> > the same name:
> > 
> >   /* look if we want to change the name of the netif */
> >   if (strcmp(udev->name, udev->dev->kernel) != 0) {
> >     ...
> >     retval = rename_netif(udev);
> >     ...
> >   }
> > 
> > What udev version is it and which distro and version?
> 
> My distro is openSUSE 10.2, which is fully patched/updated. According to YaST, I'm using version 
> 103-12 x86_64. My kernel is 2.6.23-rc2 from John Linville's git tree - I run bcm43xx-mac80211.

Oh, that's likely a bug in the SUSE versions of the persistent net
interface rules. It is calling ifrename when it needs to swap interface
names (temp rename to free the target name), that logic which may have
that bug.
For the next SUSE release, it is replaced by the (now available)
upstream stuff from the udev tree, which most distros use now, and which
should not have that problem.

Thanks,
Kay

