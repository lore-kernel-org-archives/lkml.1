Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbYKFUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbYKFUdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYKFUdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:33:03 -0500
Received: from smtp-out.google.com ([216.239.45.13]:60219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKFUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:33:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=Wp/j70TlZo8SRCT/JKbhHx+epMg5RZXQWG68Hf+ZEoDX8HEXYnNdxgLhli1usGxgh
	hZ4dZSh0HqzCLqG5a0Oig==
MIME-Version: 1.0
In-Reply-To: <20081106200746.GA3578@elte.hu>
References: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com>
	 <20081106200746.GA3578@elte.hu>
Date: Thu, 6 Nov 2008 12:32:55 -0800
Message-ID: <b040c32a0811061232j49a40ce8md32ff5e614441e38@mail.gmail.com>
Subject: Re: [patch] restore sched_exec load balance heuristics
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 12:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
> ok, this should be solved - but rather at the level of
> sched_balance_self(): it should never migrate this task over to
> another cpu, it should take away this task's load from the current
> CPU's load when considering migration.

There are two callers to sched_balance_self().  In the sched_fork
path, sched_balance_self will balance the newly forked task.  I think
it is OK to bounce a newly forked task to another CPU since current
CPU will be busy when fork returns in the parent process.

And if sched_balance_self() needs to different between fork / exec
load balance, it has to check a flag from function argument, which I
think it is better to just short circuit in sched_exec() directly.

- Ken
