Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXJYEap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXJYEap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXJYEai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:30:38 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4174 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbXJYEah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:30:37 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Is gcc thread-unsafe?
Date: Wed, 24 Oct 2007 21:29:56 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200710251358.55185.nickpiggin@yahoo.com.au>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 24 Oct 2007 21:30:54 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 24 Oct 2007 21:30:54 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Well that's exactly right. For threaded programs (and maybe even
> real-world non-threaded ones in general), you don't want to be
> even _reading_ global variables if you don't need to. Cache misses
> and cacheline bouncing could easily cause performance to completely
> tank in some cases while only gaining a cycle or two in
> microbenchmarks for doing these funny x86 predication things.

For some CPUs, replacing an conditional branch with a conditional move is a
*huge* win because it cannot be mispredicted. In general, compilers should
optimize for unshared data since that's much more common in typical code.
Even for shared data, the usual case is that you are going to access the
data few times, so pulling the cache line to the CPU is essentially free
since it will happen eventually.

Heuristics may show that the vast majority of such constructs write anyway.
So the optimization may also be valid based on such heuristics.

A better question is whether it's legal for a compiler that claims to
support POSIX threads. I'm going to post on comp.programming.threads, where
the threading experts hang out.

A very interesting case to be sure.

DS


