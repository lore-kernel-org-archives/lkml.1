Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYHYAtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYHYAtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 20:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYHYAtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 20:49:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:36389 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYHYAtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 20:49:05 -0400
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 10:48:21 +1000
Message-Id: <1219625301.13162.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11414
> Subject		: Random crashes with 2.6.27-rc3 on PPC
> Submitter	: Michael Buesch <mb@bu3sch.de>
> Date		: 2008-08-23 14:10 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=121950076812616&w=4

This appears to be a gcc bug when -fno-omit-stack-pointer is used (which
we mostly don't need on ppc anyway except that another gcc stupidity makes
it mandatory for -pg which ftrace needs).

We're working on a two fold workaround: removing -fno-omit-stack-pointer
in all the cases where we don't really need it, and for when we do (ie,
CONFIG_FTRACE becaues of -pg), using -mno-sched-epilog which seems to
work around it.

The root cause in gcc hasn't been fully identified yet.

Ben.


