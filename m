Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXCCVbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXCCVbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbXCCVbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:31:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030412AbXCCVbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:31:10 -0500
Message-ID: <45E9E910.2070804@redhat.com>
Date: Sat, 03 Mar 2007 16:30:56 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com> <20070303131204.6706a95c.akpm@linux-foundation.org>
In-Reply-To: <20070303131204.6706a95c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 03 Mar 2007 15:40:42 -0500 Rik van Riel <riel@redhat.com> wrote:

>> I am sick and tired of the "this is hard, let userspace do it" attitude.
> 
> Anything you try to do in-kernel will catastrophically screw up some
> workloads.  You don't have a chance of getting this right.

Any time you follow the directions of one userspace program,
you can screw up others.  I suspect that userspace has far
less of a chance of getting it right than the kernel.

ALSA would be a good example of why it is bad to export
tuning knobs directly to userspace - many sound cards have
non-standard names for the volume controls, making it almost
impossible for userspace to present the user with a simple
user interface for tweaking the volume.

> You are the kernel.  The user just read an entire kernel tree.  You face a
> binary decision: do you cache that tree or do you not?  Your time starts
> now.  What is your answer?

Lets turn this around.

The user has been accessing the kernel tree over and over
again, for hours on end (compile testing a patch).  Along
comes a backup program, that tells you to evict the whole
thing from the cache.

What do you do?

How can you make global policy decisions based on the intent
of one program?

Only the kernel knows the state of the whole system and has
observed the behaviour of all the processes. One process has
no idea what the other processes in the system are doing.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
