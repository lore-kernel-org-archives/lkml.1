Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbZDRJGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbZDRJGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZDRJGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:06:08 -0400
Received: from a4.complang.tuwien.ac.at ([128.130.173.65]:33413 "EHLO
	a4.complang.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZDRJGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:06:07 -0400
Subject: Re: Out-of-order writing by disk drives
To: folkert@vanheusden.com (Folkert van Heusden)
Date: Sat, 18 Apr 2009 11:06:03 +0200 (CEST)
From: "Anton Ertl" <anton@mips.complang.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090417210700.GD10554@vanheusden.com>
Reply-To: anton@mips.complang.tuwien.ac.at
X-Info: DVR-Nummer der TU Wien: 0005886
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Lv6Ut-0008Rm-Dq@a4.complang.tuwien.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden wrote:
> 
> > I have released a new version of hdtest, a program that tests whether
> > hard disks write out-of-order relative to the order that the writes
> > were passed to them from the OS.  You find the program at
> > http://www.complang.tuwien.ac.at/anton/hdtest/
> 
> Not sure if it matters but it seems open-iscsi (both target and
> initiator are linux systems) works fine with respect to the write
> barriers: while running hdtest on an iscsi device I suddenly stopped the
> traffic flowing using an iptables DROP-rule. Then of course I stopped
> the iscsi initiator, removed the rules, restarted the initator and ran
> hdcheck: all above the line have the correct magic.

hdtest does not use barriers (if it did, my results would hopefully be
different; BTW, how would I use device barriers from a user program?).
But it does write to the device opened with O_SYNC.  So I expect the
kernel to pass the request synchronously to the device (due to
O_SYNC), but the device has no particular reason (like barriers) to
write the stuff in-order.  So I would expect your disconnection not to
result in out-of-order writing just like I would not expect
disconnecting the USB or SATA connection to have that effect when
using a setup like I did (but I have not tried that).

In short, your experiment tells nothing about barriers over iSCSI,
because barriers are not used (AFAIK).

- anton
