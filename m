Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbXJRKNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbXJRKNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbXJRKNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:13:04 -0400
Received: from sandesh.cdotd.ernet.in ([196.1.105.47]:48020 "EHLO
	sandesh.cdotd.ernet.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXJRKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:13:01 -0400
From: "Deepak Gaur" <dgaur@cdotd.ernet.in>
To: linux-kernel@vger.kernel.org
Subject: post_coreinitcall and module_init() in tty_io.c linux kernel 2.6.10
Date: Thu, 18 Oct 2007 16:34:04 +0630
Message-Id: <20071018095424.M580@cdotd.ernet.in>
X-Mailer: Open WebMail 2.51 20050228
X-OriginatingIP: 192.168.1.167 (dgaur)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
X-imss-version: 2.048
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-3.3877 TC:1F TRN:35 TV:5.0.1023(15490.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:5 C:4 M:4 S:4 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am novice in field of linux device drivers. I have a small question regarding module
_init() call in file drivers/char/tty_io.c. In this file there are two init calls mentioned 

(a) postcore_initcall(tty_class_init);
(b) module_init(tty_init);

The postcore_initcall is defined in include/linux/init.h as
-----------------------------------------------------------------------
/**
 * module_init() - driver initialization entry point
 * @x: function to be run at kernel boot time or module insertion
 *
 * module_init() will either be called during do_initcalls (if
 * builtin) or at module insertion time (if a module).  There can only
 * be one per module.
 */
#define module_init(x)  __initcall(x);

/**
 * module_exit() - driver exit entry point
 * @x: function to be run when driver is removed
 *
 * module_exit() will wrap the driver clean-up code
 * with cleanup_module() when used with rmmod when
 * the driver is a module.  If the driver is statically
 * compiled into the kernel, module_exit() has no effect.
 * There can only be one per module.
 */
#define module_exit(x)  __exitcall(x);

#else /* MODULE */

/* Don't use these in modules, but some people do... */
#define core_initcall(fn)               module_init(fn)
#define postcore_initcall(fn)           module_init(fn)
#define arch_initcall(fn)               module_init(fn)
#define subsys_initcall(fn)             module_init(fn)
#define fs_initcall(fn)                 module_init(fn)
#define device_initcall(fn)             module_init(fn)
#define late_initcall(fn)               module_init(fn)

---------------------------------------------------------

It's written in quoted text that "There can only be one per module". But in tty_io.c
there are two; postcore_initcall also maps to module_init. Each call is using different
init functions and both functions seems to be required to be executed for proper
functioning of module.


So my query is 

(1) Which one of the two (postcore_initcall/module_init) get executed and when?
(2) If both get executed does it not break the rule that a kernel module should have
only one module_init() and one module_exit()?

with warm regards
 
Deepak Gaur

