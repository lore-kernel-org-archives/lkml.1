Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZEXTGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZEXTGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbZEXTGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:06:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:2174 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZEXTGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=w82niZyi03rypUuIVGjPv0z8cf9yO2uif4H5xhZvN7JC+wIOMuLQfSHiItBU7rvwyj
         WK6evIoXKLUZ2yJHYnBOuefQo2zhK0N/5eWxNU/HB6m9ojlc7o7qomG5zadmj0OOXHO9
         w++yAIwolx2Tz1ECu9d3QtwncLe7G+pTjapI4=
Message-ID: <4A199A7A.3010705@gmail.com>
Date: Sun, 24 May 2009 21:05:30 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: 2 bugs related to suspend to disk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) echo platform > /sys/power/disk; echo disk > /sys/power/state

works but prints:

BUG: sleeping function called from invalid context at include/linux/writeback.h:87
in_atomic(): 1, irqs_disabled(): 0, pid: 6509, name: sh
3 locks held by sh/6509:
 #0:  (&buffer->mutex){+.+.+.}, at: [<>] sysfs_write_file+0x38/0x119
 #1:  (pm_mutex){+.+.+.}, at: [<>] hibernate+0x17/0x169
 #2:  (swap_lock){+.+...}, at: [<>] swap_type_of+0x2e/0xed
Pid: 6509, comm: sh Not tainted 2.6.30-rc7-mod #124
Call Trace:
 ? __debug_show_held_locks
 ? bdev_test
 __might_sleep
 ifind
 ? bdev_test
 iget5_locked
 ? bdev_set
 bdget
 swap_type_of
 swsusp_write
 ? acpi_sleep_tts_switch
 hibernate
 state_store
 kobj_attr_store
 sysfs_write_file
 vfs_write
 sys_write
 system_call_fastpath

2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)

It's not a regression, because I never tried to STD (STR worked).

Marcin
