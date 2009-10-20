Return-Path: <linux-kernel-owner+w=401wt.eu-S1751162AbZJTEBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbZJTEBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZJTEBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:01:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55053 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZJTEBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:01:46 -0400
Date: Mon, 19 Oct 2009 21:03:15 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091020040315.GA26632@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdiad9jd.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| > clone3() seemed to be the leading contender from what I've read so far.
| > Does anyone still object to clone3() after reading the whole thread?
| 
| I object to what clone3() is.  The name is not particularly interesting.
| 
| The sanity checks for assigning pids are missing and there is a todo
| about it.  I am not comfortable with assigning pids to a new process
| in a pid namespace with other processes user space processes executing
| in it.

Could you clarify ? How is the call to alloc_pidmap() from clone3() different
from the call from clone() itself ?

| 
| How we handle a clone extension depends critically on if we want to
| create a processes for restart in user space or kernel space.
| 
| Could some one give me or point me at a strong case for creating the
| processes for restart in user space?

There has been a lot of discussion on this with reference to the
Checkpoint/Restart patchset. See http://lkml.org/lkml/2009/4/13/401
for instance.

| 
| The pid assignment code is currently ugly.  I asked that we just pass
| in the min max pid pids that already exist into the core pid
| assignment function and a constrained min/max that only admits a
| single pid when we are allocating a struct pid for restart.  That was
| not done and now we have a weird abortion with unnecessary special cases.

I did post a version of the patch attemptint to implement that. As
pointed out in:

	http://lkml.org/lkml/2009/8/17/445

we would need more checks in alloc_pidmap() to cover cases like min or max
being invalid or min being greater than max or max being greater than pid_max
etc. Those checks also made the code ugly (imo).

Sukadev
