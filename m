Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZIWJ1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZIWJ1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZIWJ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:27:07 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:54059 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbZIWJ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sLPVSr6eFOA0dTP/kEqkYyae4E6hLrtIDolBoaN+R3Sa3lSjXOlVyZIcg5z0EXNLxG
         45eHAOqo++L5B0zrcM2AspDOm2SmWc7U29+ohna2yfcoZLM2f716TU0SPLPKICV+TrwO
         4nLk5W682rGS1ILm0KpkRIQNFoppCJhyilED8=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 17:27:08 +0800
Message-ID: <7b6bb4a50909230227h50cccb0enb02d42664dd61872@mail.gmail.com>
Subject: BUG: sleeping function called from invalid context at 
	kernel/mutex.c:280
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    I got following messages when I resume from suspend with 2.6.31.
Is there anything wrong? Thanks.

BUG: sleeping function called from invalid context at kernel/mutex.c:280
in_atomic(): 0, irqs_disabled(): 1, pid: 2473, name: pm-suspend
2 locks held by pm-suspend/2473:
 #0:  (&buffer->mutex){......}, at: [<ffffffff8115ab13>]
sysfs_write_file+0x3c/0x137
 #1:  (pm_mutex){......}, at: [<ffffffff810865b5>] enter_state+0x39/0x130
Pid: 2473, comm: pm-suspend Not tainted 2.6.31 #1
Call Trace:
 [<ffffffff810792f0>] ? __debug_show_held_locks+0x22/0x24
 [<ffffffff8104a2ef>] __might_sleep+0x107/0x10b
 [<ffffffff8141fca9>] mutex_lock_nested+0x25/0x43
 [<ffffffff81073537>] clocksource_resume+0x1c/0x60
 [<ffffffff81072902>] timekeeping_resume+0x1e/0x1c8
 [<ffffffff812aee62>] __sysdev_resume+0x25/0xcf
 [<ffffffff812aef79>] sysdev_resume+0x6d/0xae
 [<ffffffff810864f8>] suspend_devices_and_enter+0x12b/0x1af
 [<ffffffff8108665b>] enter_state+0xdf/0x130
 [<ffffffff81085dc3>] state_store+0xb6/0xd3
 [<ffffffff81204c73>] kobj_attr_store+0x17/0x19
 [<ffffffff8115abd2>] sysfs_write_file+0xfb/0x137
 [<ffffffff811057d2>] vfs_write+0xae/0x10b
 [<ffffffff81208392>] ? __up_read+0x1a/0x7f
 [<ffffffff811058ef>] sys_write+0x4a/0x6e
 [<ffffffff81011b82>] system_call_fastpath+0x16/0x1b

Regards
Xiaotian
