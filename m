Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZBSMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZBSMhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZBSMhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:37:39 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42086 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752948AbZBSMhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:37:38 -0500
Date: Thu, 19 Feb 2009 13:37:36 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: BUG: MAX_STACK_TRACE_ENTRIES too low!
Message-ID: <alpine.LRH.2.00.0902191334550.15109@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running 2.6.29-rc5+ on PS3 (ppc64), I got the following BUG once during
bootup:

| Freeing unused kernel memory: 3436k freed
| BUG: MAX_STACK_TRACE_ENTRIES too low!
| turning off the locking correctness validator.
| Call Trace:
| [c000000006e1b640] [c00000000000f850] .show_stack+0x6c/0x16c (unreliable)
| [c000000006e1b6f0] [c00000000007cf6c] .save_trace+0xe0/0x108
| [c000000006e1b780] [c00000000007d058] .add_lock_to_list+0xc4/0x124
| [c000000006e1b830] [c0000000000816d0] .__lock_acquire+0x13c4/0x17c8
| [c000000006e1b930] [c000000000081b78] .lock_acquire+0xa4/0xec
| [c000000006e1b9f0] [c0000000003be034] ._spin_lock+0x34/0x58
| [c000000006e1ba80] [c0000000000d3e40] .kmem_cache_free+0x84/0x1a8
| [c000000006e1bb30] [c0000000001f9abc] .idr_remove+0x214/0x248
| [c000000006e1bbf0] [c00000000002867c] .destroy_context+0x34/0x64
| [c000000006e1bc80] [c00000000005008c] .__mmdrop+0x4c/0x7c
| [c000000006e1bd10] [c00000000004de90] .finish_task_switch+0xec/0x14c
| [c000000006e1bdb0] [c00000000004e6fc] .schedule_tail+0x2c/0xa0
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
| [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc

(There are 65 call trace lines)

After that the system continued.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
