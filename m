Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYH1DKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYH1DKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYH1DK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:10:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52549
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYH1DKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:10:25 -0400
Date: Wed, 27 Aug 2008 20:10:20 -0700 (PDT)
Message-Id: <20080827.201020.17601834.davem@davemloft.net>
To: juhlenko@akamai.com
Cc: andi@firstfloor.org, johnpol@2ka.mipt.ru, dada1@cosmosbay.com,
       denys@visp.net.lb, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080828023958.GB21395@juhlenko-desk.sanmateo.corp.akamai.com>
References: <87vdxmr53f.fsf@basil.nowhere.org>
	<20080827.143401.76242975.davem@davemloft.net>
	<20080828023958.GB21395@juhlenko-desk.sanmateo.corp.akamai.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Uhlenkott <juhlenko@akamai.com>
Date: Wed, 27 Aug 2008 19:39:58 -0700

> It's a *socket* option.  It's named SO_TIMESTAMP.  Users of it ought
> to *expect* that it records the time the packet hits the socket, not
> the time the frame hits the device.

When expectations equal reality, and then we change reality, that's
called breaking things.

What might (and I do mean "might") save us is how other systems
implement this.  A quick check of BSD shows that at least OpenBSD
fetches the timestamp inside of the RAW and UDP usrreq handler,
which is basically socket receive.

Our man pages simply say "reception" as when the timestamp is from,
which may also give us some more leeway.
From: Jason Uhlenkott <juhlenko@akamai.com>
Date: Wed, 27 Aug 2008 19:39:58 -0700

> > I find it amusing that nobody it talking about fixing the tools
> > that are creating the timestamp requests when they have no real
> > reason for having them in the first place.
> 
> I don't agree that the tools are broken.  Some of them may have
> frivolous reasons for wanting timestamps, but they're asking for
> something at the socket layer, with the scope of a single socket, and
> it's hardly their fault that we respond to that by doing something
> expensive and global at a much lower level.

Every application using AF_PACKET sockets gets timestamps by
default.  And we do know of several specific cases where the
timestamps are unnecessary.

Even for other cases, why in the world does a DHCP client need
accurate timestamps?  Give me a break. :)


