Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbXJYVnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbXJYVnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbXJYVnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:43:31 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4462 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbXJYVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:43:30 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 14:42:56 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEEDHMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <alpine.LFD.0.999.0710250744420.30120@woody.linux-foundation.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 25 Oct 2007 14:44:01 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 25 Oct 2007 14:44:04 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


	I asked a collection of knowledgeable people I know about the issue. The
consensus is that the optimization is not permitted in POSIX code but that
it is permitted in pure C code. The basic argument goes like this:

	To make POSIX-compliant code even possible, surely optimizations that add
writes to variables must be prohibited. That is -- if POSIX prohibits
writing to a variable in certain cases only the programmer can detect, then
a POSIX-compliant compiler cannot write to a variable except where
explicitly told to do so. Any optimization that *adds* a write to a variable
that would not otherwise occur *must* be prohibited.

	Otherwise, it is literally impossible to comply with the POSIX requirement
that concurrent modifications and reads to shared variables take place while
holding a mutex.

	The simplest solution is simply to ditch the optimization. If it really
isn't even an optimization, then that's an easy way out.

	DS


