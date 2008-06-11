Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYFKI4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYFKI4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYFKI4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:56:13 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:47703 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYFKI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:56:12 -0400
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable
	tasks over migratable ones"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1213138710.26530.51.camel@earth>
References: <1213138710.26530.51.camel@earth>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 10:53:02 +0200
Message-Id: <1213174382.31518.69.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 00:58 +0200, Dmitry Adamushko wrote:
> Hi Gregory,
> 
> 
> regarding this commit: 45c01e824991b2dd0a332e19efc4901acb31209f
> 
> 
> I think we can do it simpler. Please take a look at the patch below.
> 
> Instead of having 2 separate arrays (which is + ~800 bytes on x86_32 and twice so on x86_64),
> let's add "exclusive" (the ones that are bound to this CPU) tasks to the head of the queue
> and "shared" ones -- to the end.
> 
> In case of a few newly woken up "exclusive" tasks, they are 'stacked' (not queued as now), meaning that
> a task {i+1} is being placed in front of the previously woken up task {i}. But I don't think that
> this behavior may cause any realistic problems.

Doesn't this violate POSIX ?

