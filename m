Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYDDMsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYDDMsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758827AbYDDMr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:47:27 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49208 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758715AbYDDMrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:47:24 -0400
Message-Id: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:22:42 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: [TOMOYO #7 00/30] TOMOYO Linux 1.6.0 released
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is TOMOYO Linux for?

  It is userland applications' charge to keep processes under control.
  This includes that userland applications restrict what programs are
  permitted to execute and what files are permitted to read/write
  by the application.
  Thus, the kernel does whatever asked by the userland applications.

  But userland applications often make mistakes such as buffer overflow,
  OS command injection, directory traversal etc.
  As a result, they can't always keep processes under control.

  TOMOYO Linux is developed to take partial charge of keeping processes
  under control, by teaching the kernel what programs are
  permitted to execute and what files are permitted to read/write
  by the application and letting the kernel check it once again.

Can TOMOYO Linux coexist with SELinux, SMACK, AppArmor etc. ?

  Yes. TOMOYO Linux 1.x is not using LSM because I want don't want to disable
  different access control implementations.

  TOMOYO Linux is good at dealing with the subject's request chains,
  while LSM is good at dealing with object's life-cycle.

What are new features of this release?

  This release reinforced execution parameter checks.

  Introduced execute handler mechanism.

    The usage of TOMOYO Linux is that understand what programs are executed and
    what files are opened by individual applications and let the kernel
    enforce them. Thus, assuming that all programs needed by individual
    applications are known by the time of enforcing, attempts to execute
    not ever observed application (e.g. /bin/sh) are considered to be attacks.

    Some shellcode (an exploit code used to execute /bin/sh) attempts to
    execute /bin/sh until the execution succeeds. One of such shellcodes is
    Samba's trans2open exploit. It attempts to execute /bin/sh from infinite
    loop. As a result, just rejecting execute request of /bin/sh triggers
    CPU power consumption problem (all CPU powers are eaten by the shellcode's
    infinite loop).

    But by using execute handler, you can run different programs instead of
    just rejecting execute request to redirect the process to somewhere else.

    This redirection mechanism is useful for deploying on demand honey pot.
    You can provide regular service in peacetime, and you can redirect
    the attacker trying to start /bin/sh to honey pot in wartime.

    Also, since the fact that a program which is different from the requested
    one is executed by execute handler is not notified to the caller process,
    you can use execute handler as a transparent validation interface
    like "Web Application Firewall" or "AntiVirus". You can monitor
    parameters passed to execve() and stdio to drop unwanted parameters or
    reject the execution of the program requested by the caller process.

  Introduced "struct linux_bprm" checks.

    Proper codes tends to setting up argv[] and envp[] when executing
    a new program. But shellcodes tend to not setting up argv[] and envp[]
    when executed using buffer overflows.
    Thus, it became possible to require specific argv[] and envp[] values
    when executing a program.

  Introduced environment variable names checks.

    Some environment variables (e.g. LD_PRELOAD) are used by attackers to make
    the application behave differently.
    Thus, it became possible to restrict acceptable environment variable's
    names passed to execve().

  And various usability enhancement like more detailed access logs and
  policy management by non root user.

Is TOMOYO Linux architecture independent?

  Yes. I think TOMOYO Linux doesn't contain architecture dependent code.
  TOMOYO Linux touches only surface of the kernel code.

Are older kernels supported?

  Yes. From 2.4.30 to 2.4.36 and from 2.6.11 to 2.6.25-rc7 are supported.
  Also, various distributions' latest kernels are supported.

Where's the web page?

  http://elinux.org/TomoyoLinux
  http://tomoyo.sourceforge.jp/wiki-e/?WhatIs
  http://sourceforge.jp/projects/tomoyo/document/fosdem2008.pdf

  TOMOYO Linux is compact and suits well to PC servers and embedded systems.
  There is a TOMOYO Linux presentation at CELF Embedded Linux Conference 2008
  held in California from April 15th to the 17th.

Thank you.

