Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891Ab0ALJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0ALJHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804Ab0ALJHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:07:31 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:46999 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0ALJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:07:29 -0500
Message-ID: <4B4C3BCF.8030501@xenontk.org>
Date: Tue, 12 Jan 2010 14:37:27 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: luiz.dentz@openbossa.org
CC: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG: Commit 9e726b17 (Bluetooth: Fix rejected connection not disconnecting
 ACL link) causes trace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The commit 9e726b17 (Bluetooth: Fix rejected connection not
disconnecting ACL link) causes the following trace:

BUG: sleeping function called from invalid context at net/core/sock.c:1897
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
Pid: 0, comm: swapper Tainted: P           2.6.32 #31
Call Trace:
 <IRQ>  [<ffffffff81036455>] __might_sleep+0xf8/0xfa
 [<ffffffff8138ef1d>] lock_sock_nested+0x29/0xc4
 [<ffffffffa03921b3>] lock_sock+0xb/0xd [l2cap]
 [<ffffffffa03948e6>] l2cap_sock_shutdown+0x1c/0x76 [l2cap]
 [<ffffffff8106adea>] ? clockevents_program_event+0x75/0x7e
 [<ffffffff8106bea2>] ? tick_dev_program_event+0x37/0xa5
 [<ffffffffa0394967>] l2cap_sock_release+0x27/0x67 [l2cap]
 [<ffffffff8138c971>] sock_release+0x1a/0x67
 [<ffffffffa03d2492>] rfcomm_session_del+0x34/0x53 [rfcomm]
 [<ffffffffa03d24c5>] rfcomm_session_put+0x14/0x16 [rfcomm]
 [<ffffffffa03d28b4>] rfcomm_session_timeout+0xe/0x1a [rfcomm]
 [<ffffffff810554a8>] run_timer_softirq+0x1e2/0x29a
 [<ffffffffa03d28a6>] ? rfcomm_session_timeout+0x0/0x1a [rfcomm]
 [<ffffffff8104e0f6>] __do_softirq+0xfe/0x1c5
 [<ffffffff8100e8ce>] ? timer_interrupt+0x1a/0x21
 [<ffffffff8100cc4c>] call_softirq+0x1c/0x28
 [<ffffffff8100e05b>] do_softirq+0x33/0x6b
 [<ffffffff8104daf6>] irq_exit+0x36/0x85
 [<ffffffff8100d7a9>] do_IRQ+0xa6/0xbd
 [<ffffffff8100c493>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff812585b3>] ? acpi_idle_enter_bm+0x269/0x294
 [<ffffffff812585a9>] ? acpi_idle_enter_bm+0x25f/0x294
 [<ffffffff81373ddc>] ? cpuidle_idle_call+0x97/0x107
 [<ffffffff8100aca0>] ? cpu_idle+0x53/0xaa
 [<ffffffff81429006>] ? rest_init+0x7a/0x7c
 [<ffffffff8177bc8c>] ? start_kernel+0x389/0x394
 [<ffffffff8177b29c>] ? x86_64_start_reservations+0xac/0xb0
 [<ffffffff8177b384>] ? x86_64_start_kernel+0xe4/0xeb

since lock_sock is called from the timer function rfcomm_session_timeout.

Regards,
David.
