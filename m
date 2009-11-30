Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZK3CUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZK3CUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 21:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZK3CUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 21:20:30 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:53082 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZK3CU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 21:20:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AkZU5H//Y1u8ZY9URlZkZun6hYemq1i89ieveWGiIYcIBQvn1VjQ8HfyjHZL9kL7qh
         bQQXOKBpFbdTQhOgu1Y5VTtdC6HIk6B9KVkjPZCxhDwKukccEf7mZ230m2lk7JjmTuGY
         7B3UFg/PvIaNHZJNnBRvtnpObtLwJ192NfidU=
MIME-Version: 1.0
Date: Sun, 29 Nov 2009 18:20:35 -0800
Message-ID: <110c8b2e0911291820t410c2908t90dfc97b340b9725@mail.gmail.com>
Subject: ftrace not showing stack trace data during boot processes
From: Subodh Nijsure <nijsure.subodh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to debug some boot sequences during kernel bootup and
trying to use ftrace to discover function flow.

I am booting kernel with following options.

stacktrace trace_buf_size=30M ftrace=function
ftrace_filter=do_sync_write,usbfs*,ext2_*,vfs_write,blkdev_*,vfs_write,sys_write
ftrace_notrace=ext2_permission

I have compiled kernel with following options

CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_FUNCTION_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y

However when I look at  /sys/kernel/debug/tracing/trace

I see output similar to this and  I don't see the "stack trace"
            init-1     [000]    65.317499: sys_write <-sysenter_do_call
            init-1     [000]    65.317504: vfs_write <-sys_write
            init-1     [000]    65.317617: sys_write <-sysenter_do_call
            init-1     [000]    65.317619: vfs_write <-sys_write

Is there option I am missing while compiling kernel or some part of
kernel parameters is missing? Is there way to explicitly specify
iter_ctrl on kernel boot cmdline?

/Subodh
