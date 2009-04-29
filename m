Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZD2TWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZD2TWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbZD2TWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:22:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53915 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbZD2TWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:22:16 -0400
Date: Wed, 29 Apr 2009 15:22:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Gregory Haskins <ghaskins@novell.com>, Theodore Tso <tytso@mit.edu>
Subject: [ANNOUNCE] updated version of streamline_config.pl
Message-ID: <alpine.DEB.2.00.0904291508140.8066@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been stumbling over one of the failures of streamline config. The 
ability to add module configurations needed as a dependency for other 
modules, but do not have actual modules.

That is: If module a.ko is enabled by config CONFIG_A but depends on 
CONFIG_B, and there exists no b.ko for CONFIG_B, the script will keep 
CONFIG_A = m, but will not keep CONFIG_B = m and the "make oldconfig" will 
disable CONFIG_A.

This update solves this by not only reading the Makefiles, but it also 
reads the Kconfig* files to find all the depends for all configs. Now it 
will detect CONFIG_B is needed for CONFIG_A and keep both enabled.

The code is here:

 http://rostedt.homelinux.com/code/streamline_config.pl

And how to use it is at the top of the file.

Note, if people are still interested in adding this script to mainline, I 
can write up a patch to put it somewhere in the scripts/ directory.

-- Steve

