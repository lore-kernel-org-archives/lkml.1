Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYKXJGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYKXJGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYKXJGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:06:19 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:35583 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYKXJGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:06:18 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
 the task doesn't belong to init_task_group and when CONFIG_RT_GROUP_SCHED
 isn't set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081124084644.GA26526@linux.vnet.ibm.com>
References: <20081120061854.GA4349@in.ibm.com>
	 <1227402676.7685.19942.camel@twins> <20081124035807.GA3278@in.ibm.com>
	 <1227515526.7685.21861.camel@twins>
	 <20081124084644.GA26526@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 10:06:15 +0100
Message-Id: <1227517575.7685.21906.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 14:16 +0530, Dhaval Giani wrote:

> Which would mean the init_task_group becase it contains those tasks which are
> not grouped.

Only because of implementation details (we implement the !group case by
having them all part of a single group), conceptually they don't belong
to any group, hence talking about moving it to some group is just wrong.

Furthermore your statement shows another misconception, a group of
ungrouped tasks doesn't make sense. Either we support grouping, in which
case any task belongs to a group, or we don't and they all belong to no
(or the same) group.

