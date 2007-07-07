Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXGGB2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXGGB2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXGGB2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:28:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48828 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbXGGB2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:28:22 -0400
Subject: Re: [1/2] 2.6.22-rc7: known regressions
From: David Woodhouse <dwmw2@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz>
References: <468A7D14.1050505@googlemail.com>
	 <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com>
	 <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>
	 <200707062033.18211.dtor@insightbb.com>
	 <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 21:28:50 -0400
Message-Id: <1183771730.2789.1.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 03:05 +0200, Jiri Kosina wrote:
> On Fri, 6 Jul 2007, Dmitry Torokhov wrote:
> 
> > This is for devices using boot protocol, not full HID as far as I 
> > understand.
> 
> David,
> 
> could you please try with the trivial patch below and report the output? 
> I'd be interested to know whether we are by any chance really seeing 
> double input_unregister_device() for the same input_dev somehow. Thanks.

I suspect it's more likely that hci_conn_del_sysfs() is running and
removing the object representing the ACL connection. That's what the
input device's remove event is reporting as 'PHYSDEVPATH' on the
occasions that it _doesn't_ oops.

-- 
dwmw2


