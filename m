Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbZBQFOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbZBQFOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZBQFN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:13:57 -0500
Received: from chmailsrv.int.mrv.com ([66.43.110.11]:28028 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbZBQFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:13:57 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 00:13:56 EST
Date: Mon, 16 Feb 2009 20:58:43 -0800
From: Nye Liu <nyet@mrv.com>
To: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: modpost: Something amiss with do_hid_entry() - id->bus endianess
	wrong?
Message-ID: <20090217045840.GA28536@mrv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Feb 2009 05:01:05.0955 (UTC) FILETIME=[BD377730:01C990BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i am having problems with endianness on the id->bus value in do_hid_entry().

i think there is a "TO_NATIVE(id->bus);" missing in scripts/mod/file2alias.c:

# modinfo --version
module-init-tools version 3.4
# modinfo hid_dell
filename:
/lib/modules/2.6.28-1-amd64/kernel/drivers/hid/hid-dell.ko
license:        GPL
alias:          hid:b0300v000013BAp00000017
alias:          hid:b0300v0000413Cp00002105
alias:          hid:b0300v0000413Cp00002005
depends:        hid,usbhid
vermagic:       2.6.28-1-amd64 SMP mod_unload modversions 

notice it says "b0300", but the proper hid bus id is 0x0003 (from udev):
[ 2374.572122] dell 0003:413C:2005.0006: input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:1d.3-2/input0 

this is preventing udev from autoloading any of the usbhid modules
unless you hack modules.alias

or do i have an outdated modinfo/modutils?

-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
