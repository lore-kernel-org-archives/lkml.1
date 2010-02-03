Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab0BCUYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:24:17 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44499 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab0BCUYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:24:16 -0500
Date: Wed, 3 Feb 2010 21:24:25 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>
Subject: mtrr/state.c unused?
Message-ID: <20100203202425.GC1367@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like <arch/x86/kernel/cpu/mtrr/state.c> is not used by
anything in the kernel.

Besides cleanups, the only relevant patch in the git history is:

commit 2ec1df4130c60d1eb49dc0fa0ed15858fede6b05
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Oct 11 11:16:28 2007 +0200

    i386: move kernel/cpu/mtrr


which adds it. Hmm...

A

git log -i --pickaxe-all -Sset_mtrr_prepare_save

for example, shows that

commit 9a6b344ea967efa0bb5ca4cb5405f840652b66c4
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Mon Feb 4 16:48:01 2008 +0100

    x86: remove long dead cyrix mtrr code

has removed the last callers of those helpers and they're now unused.
They should go if we don't need them anymore.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
