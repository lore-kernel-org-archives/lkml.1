Return-Path: <linux-kernel-owner+w=401wt.eu-S1764837AbZLQOjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764837AbZLQOjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764829AbZLQOjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:39:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:59158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764816AbZLQOjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:39:08 -0500
Subject: Re: Real Time scheduler infos
From: Peter Zijlstra <peterz@infradead.org>
To: Ivan Gualandri <finarfin@dreamos.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <117cfc288d1eed419c5f296d43167116@localhost>
References: <117cfc288d1eed419c5f296d43167116@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 15:38:44 +0100
Message-ID: <1261060724.27920.442.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 15:22 +0100, Ivan Gualandri wrote:
> Hi, 
> 
> i have a question about priorities in RT patchset. 
> 
> In linux priorites are from 1 to 139 (1 highest - 139 lowest)
> And RT prorities are between 1 to 99. An i think 1 is highest and 139
> lowest.
> 
> But now if i try to launch three tasks with 3 different priorities: 
> for example 
> A has priority 10
> B has priority 20
> C has priority 30 
> I notice that the tasks B and C are always the first two to run. And A
> always wait the end of B or C (also if A is the first task launched).
> 
> Now my question is: 
> when i set priority of a RT task (changing the sched_priority field of my
> task) the highest priority is 99 or 1? 

The user exposed priorities are from low to high, that is 1 is the
lowest and 99 (POSIX compliant apps use
sched_get_priority_max(SCHED_FIFO)) is the highest priority, as
specified by POSIX.

The scheduler implementation has this reversed but that should be of no
consequence.

