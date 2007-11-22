Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbXKVL76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbXKVL76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 06:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXKVL7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 06:59:50 -0500
Received: from neopsis.com ([213.239.204.14]:39346 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752475AbXKVL7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 06:59:49 -0500
Message-ID: <47456F28.3070307@dbservice.com>
Date: Thu, 22 Nov 2007 12:59:36 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <47406CFF.8070306@dbservice.com> <200711182333.52669.rjw@sisk.pl>
In-Reply-To: <200711182333.52669.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.283,
	required 5, autolearn=spam, AWL 0.22, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 18 of November 2007, Tomas Carnecky wrote:
>> Pavel Machek wrote:
>>> Hi!
>>>
>>>> echo disk > /sys/power/state
>>>>
>>>> successfully saves that state to the disk, but just as the laptop is
>>>> about to turn itself off, it reboots (successfully, so the
>>>> hibernation/resume process works well, even with X running! which is
>>>> awesome :) ). But I'd rather like the computer turned off after I
>>>> hibernate it. Where could the problem be?
>>>>
>>>> It's a new laptop, TP X61 tablet, I tried ubuntu (7.10, gutsy) for a few
>>>> days, both suspend and hibernate worked there (with one or two crashes,
>>>> probably due to X, I've read that the intel driver got some
>>>> suspend/resume improvements recently). Now I'm running gentoo, kernel
>>>> 2.6.24-rc2. I'm using newer versions of almost all software now compared
>>>> to the ubuntu system.
>>> If it works in older ubuntu, you can probably do bisect. Does normal
>>> shutdown work? You can try platform vs. shutdown mode...
>> I forgot, normal shutdown (init 0) works, the 'shutdown' command fails
>> somewhere in the gentoo init scripts, but that has nothing to do with
>> the kernel. 'init 6' also works. Both regardless of where the notebook
>> is (dock or outside).
> 
> Please verify if you have the ehci_hcd driver loaded when the box is in the
> dock.  If so, please try to unload it before hibernation and see if the box
> will reboot.

I had to recompile the kernel because I have a monolithic kernel with as
many components as possible compiled in. But after I disabled the whole
USB subsystem, the laptop doesn't reboot anymore after hibernation. Is
that a bug in the usb driver or are users supposed to unload ehci_hcd
each time before hibernation? In the former case, I'd be willing to help
debug.

tom
