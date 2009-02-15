Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZBOLZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZBOLZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 06:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZBOLZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 06:25:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:35549 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZBOLZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 06:25:02 -0500
Subject: Re: RT scheduling and a way to make a process hang, unkillable
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <4997672B.1000301@fatooh.org>
References: <4997672B.1000301@fatooh.org>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 12:24:56 +0100
Message-Id: <1234697096.4713.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 16:51 -0800, Corey Hickey wrote:
> Hello,
> 
> I've encountered a bit of a problem in recent kernels that include
> "Group scheduling for SCHED_RR/FIFO": it is possible for a process run
> by root to hang itself and become unkillable--even by a 'kill -9'.
> 
> The following kernel options must be set:
> CONFIG_GROUP_SCHED=y
> CONFIG_RT_GROUP_SCHED=y
> CONFIG_USER_SCHED=y
> 
> The procedure is for a program to:
> 1. run as root
> 2. set SCHED_FIFO
> 3. change UID to a user with no realtime CPU share allocated

Hmm, setuid() should fail in that situation.

/me goes peek at code.

Can't find any code to make that happen, Dhaval didn't we fix that at
one point?

