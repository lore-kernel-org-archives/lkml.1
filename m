Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbYB1Ufc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbYB1Ufc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763266AbYB1UfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:35:00 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50138 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762864AbYB1Ue6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:34:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	<Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	<20080227204546.72e16e8d.akpm@linux-foundation.org>
	<1204179747.3501.21.camel@raven.themaw.net>
	<20080227223734.caab0165.akpm@linux-foundation.org>
	<1204182500.3501.49.camel@raven.themaw.net>
	<47C667EC.6060700@openvz.org>
Date: Thu, 28 Feb 2008 13:33:07 -0700
In-Reply-To: <47C667EC.6060700@openvz.org> (Pavel Emelyanov's message of "Thu,
	28 Feb 2008 10:51:08 +0300")
Message-ID: <m1oda04y9o.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:

> Why do we need the uid then? Is just pid not enough to uniquely 
> identify a task?
>
> Assuming we can get by with a pid only, this problem can be solved
> by sending a pid_nr() of a task, i.e. the pid by which this task is
> seen from an initial namespace. This pid is unique across the system
> even when pid namespaces are created.

Pavel it is never correct to use a global pid when talking to user space.
In fact the concept is just a bit dubious.  We must always translate
the pid into the pid namespace of the task we are talking to, or at
least into the pid namespace of the process that opened the file
handle, (essentially the same, but does not have races in the corner
cases).

Even in the kernel using global ids is dubious.  When dealing with
user space it is just wrong.  

Speaking of.  I think we still need work on autofs in this regard.
I know last I looked we had some outstanding issues there.

Eric
