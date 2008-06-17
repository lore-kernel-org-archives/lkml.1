Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYFQTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYFQTxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYFQTxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:53:10 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.113]:58921 "EHLO
	mail147-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbYFQTxI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:53:08 -0400
X-BigFish: VPS-48(zz1432R98dR7efV1447R1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <485815F6.20507@am.sony.com>
Date: Tue, 17 Jun 2008 12:52:22 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the kernel
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org>
In-Reply-To: <20080617190750.GA31224@logfs.org>
Content-Type: text/plain; charset=UTF-8
X-OriginalArrivalTime: 17 Jun 2008 19:52:55.0907 (UTC) FILETIME=[BC6D6B30:01C8D0B3]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Tue, 17 June 2008 11:23:18 -0700, Tim Bird wrote:
>> I'm not that happy using an ioctl for this trigger.  What is
>> the preferred method of activating a kernel feature like this?
>> I presume something in /proc or /sys, but I'm not sure.
> 
> I personally would be unhappy with any kind of interface for this.  It
> would be much nicer to make it transparent and still get the benefits.
> One option would be to start a kernel thread for the initialization and
> renice it to 19 or so.

That's an interesting idea. I'm pretty sure the product guys want
an explicit trigger, so they can make sure they've got the main
application well underway before this deferred initialization occurs.

> 
> If you want an explicit trigger, you could either hook into init_post()
> or have hooks in the open functions of drivers with deferred
> initialization.

This would presumably require multiple calls (one to the open of
each deferred module).  I would still need a trigger for the memory
free operation, unless I hardcode the order of the opening and just
"know" that the last one should free the memory.  I'll have to see
if all the modules being loaded like this have open()s.

Thanks for the ideas!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

