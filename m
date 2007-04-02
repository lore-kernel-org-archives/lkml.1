Return-Path: <linux-kernel-owner+w=401wt.eu-S934007AbXDBM14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbXDBM14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934008AbXDBM14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:27:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:60302 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934007AbXDBM1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:27:55 -0400
Date: Mon, 2 Apr 2007 14:33:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Li Yu <liyu@ccoss.com.cn>,
       yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>,
       Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <1175516515.5815.347.camel@violet>
Message-ID: <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com> 
 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn> 
 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz> 
 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
 <1175516515.5815.347.camel@violet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Marcel Holtmann wrote:

> I like this idea, but it might not solve the case where you have parts 
> of the driver in kernel space and other parts in user space. For example 
> the control of a LCD display on the keyboard. However in most cases 
> registering drivers for a report id should be enough.

Hi Marcel,

the specialized driver could hook on all reports of the device (as 
discussed a few mails ago in this thread) and have the possibility to do 
three different things with the obtained report:

- pass it back to generic hid driver for "standard" processing
- process the report, and issue input_event() itself
- pass it to hidraw and let userspace to consume it

This is going to work for the scenario you have described, right?

Thanks,

-- 
Jiri Kosina
