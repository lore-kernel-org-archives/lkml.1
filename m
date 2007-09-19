Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbXISXFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbXISXFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXISXFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:05:45 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3061 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbXISXFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:05:44 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <CFRIESEN@nortel.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: CFS: some bad numbers with Java/database threading [FIXED]
Date: Wed, 19 Sep 2007 16:05:15 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGELIGOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEELFGOAC.davids@webmaster.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 19 Sep 2007 16:04:49 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 19 Sep 2007 16:04:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Chris Friesen wrote:

> > The yielding task has given up the cpu.  The other task should get to
> > run for a timeslice (or whatever the equivalent is in CFS) until the
> > yielding task again "becomes head of the thread list".

> Are you sure this isn't happening? I'll run some tests on my SMP
> system running CFS. But I'll bet the context switch rate is quite rapid.

Yep, that's exactly what's happening. The tasks are alternating. They are
both always ready-to-run. The yielding task is put at the end of the queue
for its priority level.

There is no reason the yielding task should get less CPU since they're both
always ready-to-run.

The only downside here is that a yielding task results in very small
timeslices which causes cache inefficiencies. A sane lower bound on the
timeslice might be a good idea. But there is no semantic problem.

DS


