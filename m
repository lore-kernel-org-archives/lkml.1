Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbXIPH6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbXIPH6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 03:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbXIPH6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 03:58:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35657 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXIPH6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 03:58:13 -0400
Message-ID: <46ECE20F.5020609@pobox.com>
Date: Sun, 16 Sep 2007 03:58:07 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ICH Intel PATA short cable override...
References: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com> <20070906014209.142382c8@the-village.bc.nu> <46DF63F8.8070805@rtr.ca> <46E1DC6E.9060001@pobox.com> <46E53554.1090604@rtr.ca>
In-Reply-To: <46E53554.1090604@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> Mark Lord wrote:
>>> Ditto for selecting transfer modes.
>>
>>
>> Waiting on one thing AFAICS:
>>
>>     ability to drain/idle all ports +
>>     issue a command on one port +
>>     resume normal parallel port operation
>>
>> SET FEATURES - XFER MODE is special in that it requires all sorts of 
>> additional controller handling and careful cross-port synchronization.
> 
> Absolutely.
> 
> Also note that I'm *not* advocating HDIO_SET_PIO_MODE (and kin) here,
> but rather perhaps a sysfs option per-drive.  It is needed, especially for
> custom/embedded systems, and I suppose we will get there eventually.  :)

(did I reply to this already?  I forget)

We don't need any sysfs options.  Just normal SG_IO sending a SET 
FEATURES - XFER MODE command to the desired device.

Currently, that [sub-]command is intentionally filtered out because of 
the problems that would ensue.

Once the above EH mods are in place, we simply remove that filter, and 
The Right Thing(tm) happens when you submit an ATA command via normal 
methods.  No need for new sysfs hooks or new ioctls or anything.

	Jeff



