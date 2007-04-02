Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXDBQrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXDBQrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXDBQrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:47:41 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:45064 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365AbXDBQrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:47:40 -0400
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Li Yu <liyu@ccoss.com.cn>,
       yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>,
       Li Yu <raise.sail@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>
	 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
	 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
	 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
	 <1175516515.5815.347.camel@violet>
	 <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 18:47:19 +0200
Message-Id: <1175532439.5815.375.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > I like this idea, but it might not solve the case where you have parts 
> > of the driver in kernel space and other parts in user space. For example 
> > the control of a LCD display on the keyboard. However in most cases 
> > registering drivers for a report id should be enough.
> 
> the specialized driver could hook on all reports of the device (as 
> discussed a few mails ago in this thread) and have the possibility to do 
> three different things with the obtained report:
> 
> - pass it back to generic hid driver for "standard" processing
> - process the report, and issue input_event() itself
> - pass it to hidraw and let userspace to consume it
> 
> This is going to work for the scenario you have described, right?

it will work. However I am not sure that is the best design. We need to
make one round-trip into an extra driver. We might gonna need these kind
of driver that hook in-between and does nasty things anyway, because of
broken HID devices.

The cleanest solution without a layer violation is that you can register
a driver for a specific VID/PID and then report id (one or more). All
reports with ids that we don't have a special driver for are handled by
the default HID->input driver or handed over to hidraw if not parseable.
The reports for ids with a special driver are handed over to the driver.

And for hidraw it would be nice if we can apply filters for specific
report ids to keep the round-trips and overhead at a minimum.

Regards

Marcel


