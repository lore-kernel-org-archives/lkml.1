Return-Path: <linux-kernel-owner+w=401wt.eu-S937170AbZDIXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937170AbZDIXG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbZDIXGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:06:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZDIXGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:06:48 -0400
Message-ID: <49DE7F79.4030106@zytor.com>
Date: Thu, 09 Apr 2009 16:06:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/6] x86, setup: "glove box" BIOS interrupts
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patchset to "glove box" off BIOS interrupts in the x86 setup
code, thus hopefully dealing once and for all with the problems of
BIOSes touching registers they shouldn't.

The concept is simple: we manipulate a register image in memory, then
swap it in immediately before calling the BIOS, and then switch the
register file back.  All BIOS interrupts are channeled through this path.

The increase in size is about 8% or ~1.3K in the maximal case.

  arch/x86/boot/Makefile                   |    5 +-
  arch/x86/boot/a20.c                      |    9 +-
  arch/x86/boot/apm.c                      |   76 +++++--------
  arch/x86/boot/bioscall.S                 |   82 +++++++++++++
  arch/x86/boot/boot.h                     |   48 ++++++++
  arch/x86/boot/edd.c                      |   71 +++++-------
  arch/x86/boot/header.S                   |    2 +-
  arch/x86/boot/main.c                     |   39 ++++---
  arch/x86/boot/mca.c                      |   27 ++---
  arch/x86/boot/memory.c                   |   81 +++++++-------
  arch/x86/boot/regs.c                     |   29 +++++
  arch/x86/boot/setup.ld                   |    6 +
  arch/x86/boot/tty.c                      |   52 +++++----
  arch/x86/boot/video-bios.c               |   27 ++---
  arch/x86/boot/video-vesa.c               |  137 ++++++++++------------
  arch/x86/boot/video-vga.c                |   95 +++++++++------
  arch/x86/boot/video.c                    |   42 +++----
  arch/x86/boot/video.h                    |   14 ---
  arch/x86/kernel/acpi/realmode/Makefile   |    2 +-
  arch/x86/kernel/acpi/realmode/bioscall.S |    1 +
  arch/x86/kernel/acpi/realmode/regs.c     |    1 +
  21 files changed, 490 insertions(+), 356 deletions(-)

