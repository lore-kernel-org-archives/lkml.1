Return-Path: <linux-kernel-owner+w=401wt.eu-S1763221AbXHWUkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763221AbXHWUkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbXHWUki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:40:38 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4217 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbXHWUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:40:37 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 11/23] make atomic_read() and atomic_set() behavior consistent on m32r
Date: Thu, 23 Aug 2007 13:39:54 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEACGGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <alpine.LFD.0.999.0708231310430.30176@woody.linux-foundation.org>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 23 Aug 2007 13:40:28 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 23 Aug 2007 13:40:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 23 Aug 2007, Segher Boessenkool wrote:

> The combining, which I've mentioned *multiple*times* is
>
> 	if (atomic_read(&x) <= 1)
>
> and dammit, if that doesn't result in a *single* instruction, the code
> generation is pure and utter crap.
>
> It should result in
>
> 	cmpl $1,offset(reg)
>
> and nothing else. And there is no way in hell you are doing that with
> "atomic_read()" being inline asm.

Sorry, Linus, I don't agree. The whole point of 'volatile' is to say to the
compiler, "DO NOT OPTIMIZE THIS. What you think is harmless may break things
you do not and should not understand." The combination of the read and the
compare into a single operation is a compiler optimization.

While it would not be unreasonable to still allow this optimization (since I
cannot think of any situations in which it could be harmful), it is just as
reasonable not to.

DS


