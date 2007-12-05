Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbXLEDBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbXLEDBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXLEDBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:01:11 -0500
Received: from toq2-srv.bellnexxia.net ([209.226.175.121]:37782 "EHLO
	toq2-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXLEDBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:01:11 -0500
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 22:01:10 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKegVUdFn+Sr/2dsb2JhbACpBQ
Date: Tue, 4 Dec 2007 21:51:54 -0500
From: Mike Houston <mikeserv@bmts.com>
To: linux-kernel@vger.kernel.org
Cc: mhoffman@lightlink.com
Subject: 2.6.24-rc4 hwmon it87 probe fails
Message-Id: <20071204215154.7f26285e.mikeserv@bmts.com>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally got around to testing Linux 2.6.24 (2.6.24-rc4) and found
that the it87 driver fails to probe and consequently, my sensors no
longer work. This was fine with Linux 2.6.23.8 (the last kernel I was
using)

The necessary modules load, but:

it87: Found IT8718F chip at 0x290, revision 2
it87: in3 is VCC (+5V)
it87 it87.656: Failed to request region 0x290-0x297
it87: probe of it87.656 failed with error -16

Coretemp still works.

It appears it has something to do with the ioport range being
reserved for some reason:

system 00:01: ioport range 0x290-0x29f has been reserved

At least I don't see that happening on previous kernels.

In any case, the changes to it87.c itself don't appear to have caused
this. (CC'd hwmon maintainer anyways, my apologies if that was
inappropriate)

dmesg:
http://www.mikeserv.com/temp/dmesg-2.6.24-rc4.txt

config:
http://www.mikeserv.com/temp/config-2.6.24-rc4.txt

Thanks for any help or suggestions,

Mike Houston
