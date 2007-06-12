Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbXFLSRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbXFLSRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbXFLSRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:17:35 -0400
Received: from eazy.amigager.de ([213.239.192.238]:38996 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbXFLSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:17:34 -0400
Date: Tue, 12 Jun 2007 20:17:32 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Message-ID: <20070612181732.GA8831@dose.home.local>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de> <200705281406.57396.david-b@pacbell.net> <20070531043229.GA30888@dose.home.local> <20070531102603.GA16719@srcf.ucam.org> <20070601074606.GA6060@dose.home.local> <20070601125422.GA12204@srcf.ucam.org> <20070604093518.GA29240@dose.home.local> <20070604121457.GA26615@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604121457.GA26615@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 13:14:58 +0100, Matthew Garrett wrote:
> On Mon, Jun 04, 2007 at 11:35:18AM +0200, Tino Keitel wrote:
>
> (By the way, it helps if you Cc: me - it's easy to lose track of
> things
> in the LKML noise)
>
> > Here it is:
> >
> > state = active
> > io 0x70-0x77
> > options
>
> Yes, there's no IRQ listed. Can you try current git?

OK, it works with git 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
(something after -rc4). I can echo something into
/sys/class/rtc/rtc0/wakealarm and the machine will wake up from suspend
to RAM.

However, a minor glitch remains:

$ echo 1181672013 > /sys/class/rtc/rtc0/wakealarm

- suspend

- wait for wakeup

After wakeup:

$ cat /sys/class/rtc/rtc0/wakealarm
2051656909

Regards,
Tino
