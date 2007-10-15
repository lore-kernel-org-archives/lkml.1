Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXJOOio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXJOOio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXJOOig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:38:36 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1432 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXJOOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:38:36 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [rfc][patch 3/3] x86: optimise barriers
Date: Mon, 15 Oct 2007 07:38:29 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEMEHHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071015074405.GA1875@ff.dom.local>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 15 Oct 2007 07:39:11 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 15 Oct 2007 07:39:11 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Intel(R) 64 and IA-32 Architectures Software Developer's Manual
> Volume 3A:
>
>    "7.2.2 Memory Ordering in P6 and More Recent Processor Families
>     ...
>     1. Reads can be carried out speculatively and in any order.
>     ..."
>
> So, it looks to me like almost the 1-st Commandment. Some people (like
> me) did believe this, others tried to check, and it was respected for
> years notwithstanding nobody had ever seen such an event.

When Intel first added speculative loads to the x86 family, they pegged the
speculative load to the cache line. If the cache line is invalidated, so is
the speculative load. As a result, out-of-order reads to normal memory are
invisible to software. If a write to the same memory location on another CPU
would make the fetched value invalid, it will make the cache line invalid,
which invalidates the fetch.

I think it's extremely unlikely that any x86 CPU will do this any
differently. It's hard to imagine Intel and AMD would go to all this trouble
for so long just to stop so late in the line's lifetime.

DS


