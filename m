Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbXE0WSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbXE0WSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXE0WSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:18:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbXE0WSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:18:01 -0400
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
	hibernation/suspend
From: Kay Sievers <kay.sievers@vrfy.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <20070527220412.GC22687@srcf.ucam.org>
References: <200705272229.21263.rjw@sisk.pl>
	 <200705272231.54535.rjw@sisk.pl> <20070527204955.GA22202@srcf.ucam.org>
	 <3ae72650705271449q37f523c3t5980541122ab871@mail.gmail.com>
	 <20070527220412.GC22687@srcf.ucam.org>
Content-Type: text/plain
Date: Mon, 28 May 2007 00:16:06 +0200
Message-Id: <1180304166.3131.66.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/vtlNTVUrdlkrAnM1g2c3yL/0LwOY4UqgumDS
 IbpnIfjvairHHhHqdlendAjqztFYt0iP+Um/Kowq5Rtb9mo7ZC
 TkAcEs1AMZVuSC/P9oTBktDl02kpjnq
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 23:04 +0100, Matthew Garrett wrote:
> On Sun, May 27, 2007 at 11:49:30PM +0200, Kay Sievers wrote:
> 
> > What exactly is the problem we see here? The timeout of the firmware loader?
> > What goes wrong with frozen userspace, usually there is only a netlink
> > message sent from the kernel, which should be received and handled
> > just fine when userspace is running again.
> 
> Driver calls request_firmware in the resume method. The userspace helper 
> can't be run because it's been frozen, so the firmware never gets loaded 
> and the call times out. The driver then fails to resume. While all this 
> is happening, the rest of the kernel is blocking on that resume method. 
> The firmware can be loaded once userspace has been started again, but by 
> that time the driver has given up.

Seems, that's just the broken synchronous firmware loading interface
with the useless timeout handling. The nowait version of the same loader
doesn't time out, and should not have that problem. The sync version
should be removed from the kernel, it just causes all sorts of problems
since it exists.

Userspace should handle the async request just fine when it comes back
running, regardless of the time it was submitted.

Kay

