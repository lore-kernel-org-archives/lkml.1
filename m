Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYCCMmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYCCMmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYCCMmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:42:42 -0500
Received: from ns1.suse.de ([195.135.220.2]:46845 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbYCCMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:42:41 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, chris.mason@oracle.com
Subject: Re: [patch 0/2] object debugging infrastructure
From: Andi Kleen <andi@firstfloor.org>
References: <20080301100019.640027768@linutronix.de>
Date: Mon, 03 Mar 2008 13:42:40 +0100
In-Reply-To: <20080301100019.640027768@linutronix.de> (Thomas Gleixner's message of "Sat\, 01 Mar 2008 10\:24\:52 -0000")
Message-ID: <p73ir046ksf.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
>
> The debugobjects core code keeps track of operations on static and
> dynamic objects by inserting them into a hashed list and sanity
> checking them on object operations and providing additional checks
> whenever kernel memory is freed.

Nice idea to make this generic.

If you push this it would be also good to consider some variant
of the "crasher" code that is in SUSE Kernels to include with it. 

It was originally written by Chris Mason and it also makes it easier
to stabilize such bugs. The basic idea is that a background thread
allocates lots of slabs and pages always poisons them and checks them
in the background. If someone corrupts memory that is noticed earlier
then

Basically it extends what your patchkit is doing to free memory too.

Chris' old patch:
http://firstfloor.org/~andi/crasher-26.diff
(various variants of that have existed over time) 


-Andi
