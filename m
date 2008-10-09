Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYJIQk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYJIQk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYJIQkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:40:20 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2655 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYJIQkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:40:19 -0400
Date: Thu, 9 Oct 2008 18:40:17 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.27-rc6 Power5 64bit]  kobject (c000000043442790): tried to
	init an initialized object, something is seriously wrong.
Message-ID: <20081009164013.GH28224@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Oct 10 14:44:58 CEST 2008
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

New problem occured while repeating something.
While running my modprobe/rmmod fiddle script I ran a couple of times a
find /sys -type f| xargs cat > /dev/null
This gave me a new problem:

[   49.619719] kobject (c000000043442790): tried to init an initialized object, something is seriously wrong.
[   49.619739] Call Trace:
[   49.619755] [c000000044a7b450] [c00000000000f900] .show_stack+0x70/0x184 (unreliable)
[   49.619776] [c000000044a7b500] [c0000000001cd2bc] .kobject_init+0x58/0xa4
[   49.619792] [c000000044a7b590] [c0000000001cda78] .kobject_init_and_add+0x38/0x70
[   49.619811] [c000000044a7b640] [c0000000001bff3c] .blk_register_filter+0x50/0x84
[   49.619833] [c000000044a7b6d0] [d0000000001012a0] .sr_probe+0x58c/0x64c [sr_mod]
[   49.619852] [c000000044a7b7d0] [c0000000002f0a50] .driver_probe_device+0x13c/0x200
[   49.619869] [c000000044a7b860] [c0000000002f0b74] .__driver_attach+0x60/0xa4
[   49.619884] [c000000044a7b8f0] [c0000000002efe10] .bus_for_each_dev+0x80/0xd8
[   49.619900] [c000000044a7b9b0] [c0000000002f07b4] .driver_attach+0x28/0x40
[   49.619916] [c000000044a7ba30] [c0000000002f03f8] .bus_add_driver+0xd8/0x288
[   49.619931] [c000000044a7bad0] [c0000000002f0f84] .driver_register+0xc4/0x198
[   49.619992] [c000000044a7bb80] [d0000000000a72a4] .scsi_register_driver+0x20/0x38 [scsi_mod]
[   49.620013] [c000000044a7bc00] [d000000000102c54] .init_sr+0x40/0xc4c [sr_mod]
[   49.620030] [c000000044a7bc90] [c000000000009248] .do_one_initcall+0x8c/0x1c0
[   49.620047] [c000000044a7bd90] [c0000000000a8b0c] .sys_init_module+0xc4/0x200
[   49.620062] [c000000044a7be30] [c0000000000086b4] syscall_exit+0x0/0x40


Folkert van Heusden

-- 
MultiTail är en flexibel redskap för att fälja logfilar, utför av
commandoer, filtrera, ge färg, sammanfoga, o.s.v. följa.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
