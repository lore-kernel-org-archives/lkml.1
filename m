Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbXDBMWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbXDBMWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbXDBMWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:22:13 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:44653 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007AbXDBMWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:22:12 -0400
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
From: Marcel Holtmann <marcel@holtmann.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Li Yu <liyu@ccoss.com.cn>,
       yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>,
       Li Yu <raise.sail@gmail.com>
In-Reply-To: <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>
	 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
	 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
	 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:21:55 +0200
Message-Id: <1175516515.5815.347.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> > The crucial thing here is that all reports but the ones that the driver
> > registered to will be processed in a standard way by the generic hid bus
> > layer, and those reports that the driver registered to will be ignored by
> > the layer, and passed for processing to the driver.
> >
> 
> I don't think it is a good idea to register driver for specific
> usages/reports. Quite often you want to adjust processing of a report
> for a specific device. What if there are 2 devices that need such
> quirks? How will you do hotplug and module loading? Emit new uevent
> for every report? Also, what about users and Kconfig? "Driver for
> usage 0x000012345. Say Y if your hardware does not wotk correctly with
> defautl handler for this usage and require special processing"???
> 
> Just register based on VID/PID and provide standard
> hid_default_input_event() to drivers so they would call it for reports
> they don't need to do special processing on.

I like this idea, but it might not solve the case where you have parts
of the driver in kernel space and other parts in user space. For example
the control of a LCD display on the keyboard. However in most cases
registering drivers for a report id should be enough.

Regards

Marcel


