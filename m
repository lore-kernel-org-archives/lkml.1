Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYFPRsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYFPRsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYFPRr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:47:56 -0400
Received: from mx1.suse.de ([195.135.220.2]:47999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYFPRrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:47:55 -0400
Subject: AMD Mobile Semprons (3500+, 3600+,...) break with nohz and highres
	enabled
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>,
       Richard <tuxbox.guru@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       eumaster@gmail.com, uli.geins@geins-web.de
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Mon, 16 Jun 2008 19:47:53 +0200
Message-Id: <1213638474.1684.21.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we got a bit further, Evgeny was able to get C-states working with
"nohz=off highres=off" boot parameters.

A short summary what has been found out that far:
  - apic timer breaks on C2 or deeper
  - noapictimer workaround helps to come a bit further, but results in sever
    other errors (see comment #13)
  - "nohz=off highres=off" works (tested on 2.6.25.4-8-pae and
    2.6.22.17-0.1-default SUSE kernels)
  - processor.max_cstate=1 works
  - This affects AMD Mobile Semprons (at least 3500+ and 3600+)


The output of /proc/acp/processor/*/power without highres/nohz
looks promising:
states:
    C1:                  type[C1] promotion[C2] demotion[--] latency[000]
usage[00000030] duration[00000000000000000000]
    C2:                  type[C2] promotion[C3] demotion[C1] latency[005]
usage[00002135] duration[00000000000011279621]
   *C3:                  type[C3] promotion[--] demotion[C2] latency[020]
usage[00034222] duration[00000000000228307174]


Also see bug:
https://bugzilla.novell.com/show_bug.cgi?id=396220
and some posts from Richard on the linux-acpi list.

﻿
This seem to be a mainline kernel regression since the nohz/highres
patches have been added.
I do not own such a machine myself (Richard, Evgeny, Uli (and Anvin?)
have such a machine and already helped to come that far).

Also the highres/nohz parts are a dark area to me... Any pointer how to
debug (or debug patches or patches to test), where to look at, etc. is
very much appreciated.

Thanks,

   Thomas

