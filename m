Return-Path: <linux-kernel-owner+w=401wt.eu-S2992909AbXDDOzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992909AbXDDOzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992914AbXDDOzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:55:13 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:48492 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992909AbXDDOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:55:11 -0400
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Li Yu <raise.sail@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>
	 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
	 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
	 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
	 <1175516515.5815.347.camel@violet>
	 <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>
	 <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com>
	 <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 16:54:49 +0200
Message-Id: <1175698489.5815.450.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > What's the position of hidraw? It only is used when all other driver is 
> > not usable on some report? or, it should be stick every working device.
> 
> Current implementation (as you can see it in -mm or in my hid.git tree) is 
> creating hidraw interface for just every HID device/interface. But this 
> will get changed before merge.
> 
> Passing just everything to hidraw is not a good option, as this could lead 
> to confusion and duplicating of input events (i.e. in-kernel hid driver 
> processes the report and generates input_event(), and also userland driver 
> obtains data from hidraw and generates input event through uinput ... not 
> good).

at some point I thought it would be nice to have something like hiddump
(like tcpdump), but that can be easily achieved with hcidump and usbmon
on the lower level.

So if hidraw claims a report id, the kernel should no longer handle it.

Regards

Marcel


