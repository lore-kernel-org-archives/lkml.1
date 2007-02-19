Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbXBSVNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbXBSVNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbXBSVNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:13:06 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:49545 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689AbXBSVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:13:05 -0500
Message-ID: <45DA12D5.6090905@nortel.com>
Date: Mon, 19 Feb 2007 15:12:53 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: wierd bug, help decoding sysrq output?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2007 21:12:58.0626 (UTC) FILETIME=[BB232E20:01C7546A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm looking for some help decoding an x86 stack trace.

We have a process showing as defunct, but its parent is listed as init. 
  It shows up in top as using basically 100% cpu, and one cpu out of 
four is showing spending all its time in "sys".

Dumping all tasks via sysrq gave the following information for the 
affected process:


oamFmLogServe X C8A5E610     0 23551      1         23553 20706 (L-TLB)
ee45fe58 00000046 c8a5ebf0 c8a5e610 00000a3c 00000000 00000003 c04cfb74
        f91a919f c01406ce c8a5ebf0 00000000 c8a5e610 c515c060 00000001 
00000174
        e132a861 00000a3c c8a5e610 c8a5ebf0 c8a5ed64 00005bff c8a5e610 
00000020
Call Trace:
  [<c011e742>] do_exit+0x31e/0x48a
  [<c011e95e>] do_group_exit+0x3a/0xa9
  [<c01277d1>] get_signal_to_deliver+0x21f/0x342
  [<c010238a>] do_signal+0x72/0x12f
  [<c0102482>] do_notify_resume+0x3b/0x3d
  [<c010265e>] work_notifysig+0x13/0x15


Disassembling vmlinux gives:

0xc011e73d <do_exit+793>:       call   0xc046194c <schedule>
0xc011e742 <do_exit+798>:       ud2a

I haven't been able to find any kernel code that would match up to a 
program counter of "C8A5E610".

Anyone have any ideas?

Chris
