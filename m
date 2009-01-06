Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZAFDGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZAFDGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZAFDGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:06:30 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:35009 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbZAFDGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:06:30 -0500
Message-ID: <4962CAAE.6090300@ct.jp.nec.com>
Date: Mon, 05 Jan 2009 19:06:22 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC -tip 0/4] x86: reduce fixup of uaccess
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my second try to reduce fixup code size for exceptions of uaccess.

This patch series reduces fixup code for exceptions of uaccess in signal.

I gave up to make direct jump to end of function when an exception occurs.
However, I thought fixup code could be reduced. The concept is that to add
uaccess_err in thread_info and set it to -EFAULT on exception, finally check
this value on the last of function.

Is this good to reduce code size?

The code size reductions are below;
$ size *signal*.o.*
   text	   data	    bss	    dec	    hex	filename
   4741	      0	      0	   4741	   1285	ia32_signal.o.new
   6006	      0	      0	   6006	   1776	ia32_signal.o.old
   3577	      0	      0	   3577	    df9	signal.o.new
   4540	      0	      0	   4540	   11bc	signal.o.old
   3855	      0	      0	   3855	    f0f	signal32.o.new
   4876	      0	      0	   4876	   130c	signal32.o.old

Thanks,
Hiroshi
