Return-Path: <linux-kernel-owner+w=401wt.eu-S939179AbXG3XKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939179AbXG3XKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936504AbXG3XK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:10:27 -0400
Received: from mail-04.jhb.wbs.co.za ([196.2.97.3]:41787 "EHLO
	mail-04.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763081AbXG3XK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:10:26 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 19:10:25 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABMKrkbEHh/F/2dsb2JhbAA
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Steven <hairpinblue@yahoo.com>
Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM: Introduce pm_power_off_prepare"
Date: Tue, 31 Jul 2007 00:59:45 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200707251446.56809.rjw@sisk.pl> <200707261629.55741.rjw@sisk.pl> <f8lmhe$o10$1@sea.gmane.org>
In-Reply-To: <f8lmhe$o10$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707310059.45229.bonganilinux@mweb.co.za>
X-Original-Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM: Introduce pm_power_off_prepare"
X-Scan-Signature: 934eb1fc7ecfe657c8453d18f79704ce
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2007 23:51:42 Steven wrote:
> On Thu, 26 Jul 2007 16:29:55 +0200, Rafael J. Wysocki wrote:
> > OK, so here it goes again with a changelog:
> >
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Generally, sysdev_shutdown() should be called after the ACPI preparation
> > for powering the system off.  To make it happen, we can separate
> > sysdev_shutdown() from device_shutdown() and call it directly wherever
> > necessary.
>
> Has this patch become part of the official git tree (git://git.kernel.org/
> pub/scm/linux/kernel/git/torvalds/linux-2.6.git)?  If not then are there
> plans to make it part of the official git tree?
>

Yes it is. 

commit 58b3b71dfaaecbf7cff1fe10c049d663f0313e5f
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 26 16:29:55 2007 +0200

    Fix ThinkPad T42 poweroff failure introduced by by "PM: Introduce 
pm_power_off_prepare"

    Commit bd804eba1c8597cbb7cd5a5f9fe886aae16a079a ("PM: Introduce
    pm_power_off_prepare") caused problems in the poweroff path, as reported 
by
    YOSHIFUJI Hideaki / åè¤è±æ.

    Generally, sysdev_shutdown() should be called after the ACPI preparation 
for
    powering the system off.  To make it happen, we can separate 
sysdev_shutdown()
    from device_shutdown() and call it directly wherever necessary.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Tested-by: YOSHIFUJI Hideaki / åè¤è±æ <yoshfuji@linux-ipv6.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
