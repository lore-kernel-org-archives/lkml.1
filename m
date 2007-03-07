Return-Path: <linux-kernel-owner+w=401wt.eu-S965496AbXCGN5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496AbXCGN5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965503AbXCGN5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:57:53 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:55194 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496AbXCGN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:57:51 -0500
Message-Id: <200703071353.l27DrdUx030558@sdl99w.sdl.hitachi.co.jp>
Date: Wed, 07 Mar 2007 22:53:54 +0900
From: Yuji Kakutani <yuji.kakutani.uw@hitachi.com>
X-Mailer: EdMax Ver2.85.5F
MIME-Version: 1.0
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, miklos@szeredi.hu,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, tomoki.sekiyama.qu@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional writers
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
In-Reply-To: <loom.20070301T133046-12@post.gmane.org>
References: <loom.20070301T133046-12@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thank you for your comments.

Leroy van Logchem wrote:
>The default dirty_ratio on most 2.6 kernels tend to be too large imo.
>If you are going to do sustained writes multiple times the size of
>the memory you have at least two problems.
>
>1) The precious dentry and inodecache will be dropped leaving you with
>a *very* unresponsive system
>2) The amount of dirty_pages which need to be flushed to disk is huge,
>taking all VM while the i/o channel takes uninterruptable time to　flush it.

I agree that the default dirty_ratio is too large.
What I have observed is that write(2) to a disk only with light load is
blocked in balance_dirty_pages() due to heavy write to *another* disk,
and doesn't seem to be the same issue as you say. But decreasing
dirty_ratio shortens the blocking time also in our experiments.

>What we really need is a 'cfq' for all processes -especially misbehaving
>ones like dd if=/dev/zero of=/location/large bs=1M count=10000-.
>If you want to DoS the 2.6 kernel, start a ever running dd write and
>you know what I mean. Huge latencies due the fact that all name_to_inode
>caches are lost and have to be fetched from disk again only to be quickly
>flushed again and again. I already explained this disaster scenario with
>Linus, Andrew and Jens; hoping for a auto-tuning solution which takes
>diskspeed per partition into account.

I appreciate for your information.
Would you know about any progress in this issue?


Regards,
-- 
Tomoki Sekiyama & Yuji Kakutani
Hitachi, Ltd., Systems Development Laboratory

