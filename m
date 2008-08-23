Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYHWImk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYHWImk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 04:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYHWImb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 04:42:31 -0400
Received: from torres.zugschlus.de ([85.214.68.41]:35251 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYHWIma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 04:42:30 -0400
Date: Sat, 23 Aug 2008 10:42:28 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.26.3 mount process looping on ext3 rw remount
Message-ID: <20080823084228.GA21293@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on my laptop, I am a heavy user of laptop-mode and suspend-to-disk.
Sometimes (maybe once out of ten), when disconnecting or connecting
external power, I have a mount process called by laptopmode busy
looping and taking all available CPU:

  ├─acpid,4680 -c /etc/acpi/events
  │   └─lm_ac_adapter.s,29317 /etc/acpi/actions/lm_ac_adapter.sh
  │       └─laptop_mode,29318 /usr/sbin/laptop_mode auto
  │           └─laptop-mode,29386 /usr/share/laptop-mode-tools/modules/laptop-mode
  │               └─laptop-mode,29390 /usr/share/laptop-mode-tools/modules/laptop-mode
  │                   └─laptop-mode,29409 /usr/share/laptop-mode-tools/modules/laptop-mode
  │                       └─mount,29410 /dev/mapper/usr /mnt/usr -t ext3 -o remount,rw,commit=600

this is what top says
Cpu(s):  2.7%us, 96.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  1.3%hi,  0.0%si, 0.0%st
29410 root      20   0  2068  684  564 R 92.7  0.0  87:37.71 mount

The mount process does not react to SIGKILL, stracing the looping
process doesn't give any output, and the strace gets stuck and does
not react to Ctrl-C. A SIGKILL works for the strace process, though.

To me as a layman this looks like the mount process gets stuck
somewhere in kernel land. I currently have the issue with 2.6.26.3.

In the situation of plugging and/or unplugging the power, the notebook
used to completely freeze in the time when 2.6.24 and 2.6.25.$SMALL
were in use, with 2.6.25.$HIGH and 2.6.26 I haven't hat these freezes
any more. However, I am now plagued with the hanging mount processes.

Any ideas?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
