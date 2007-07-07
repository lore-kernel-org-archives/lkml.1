Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbXGGSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbXGGSaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXGGSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:30:21 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:53943 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXGGSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:30:21 -0400
Subject: Re: [1/2] 2.6.22-rc7: known regressions
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dtor@insightbb.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
In-Reply-To: <1183775126.3066.5.camel@shinybook.infradead.org>
References: <468A7D14.1050505@googlemail.com>
	 <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com>
	 <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>
	 <200707062033.18211.dtor@insightbb.com>
	 <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz>
	 <1183771730.2789.1.camel@shinybook.infradead.org>
	 <1183775126.3066.5.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 20:28:33 +0200
Message-Id: <1183832913.6351.130.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > I suspect it's more likely that hci_conn_del_sysfs() is running and
> > removing the object representing the ACL connection. That's what the
> > input device's remove event is reporting as 'PHYSDEVPATH' on the
> > occasions that it _doesn't_ oops. 
> 
> Yes, that seems to be it. It happens when we hit the idle_timeout and
> the kernel tears down the connection. Adding a mdelay(5000) into
> hidp_session() just before calling input_unregister_device(), and
> hard-coding idle_to to 1 second, makes it nice and easy to reproduce...
> 
> Marcel? Can we deregister the input devices earlier...?

looks good to me.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


