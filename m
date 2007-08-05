Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbXHEVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbXHEVjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 17:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbXHEVjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 17:39:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761164AbXHEVjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 17:39:23 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: SysV IPC: shmctl/msgctl/semctl returns EIDRM instead of EINVAL
References: <m3bqdo1otl.fsf@neuro-laptop.skynet>
From: Anton Arapov <aarapov@redhat.com>
X-URL: http://people.redhat.com/aarapov
Date: Sun, 05 Aug 2007 23:37:15 +0200
In-Reply-To: <m3bqdo1otl.fsf@neuro-laptop.skynet> (Anton Arapov's message of "Fri\, 03 Aug 2007 19\:59\:50 +0200")
Message-ID: <m38x8pr7ck.fsf@neuro-laptop.skynet>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Please, fellas, take a look on my post!

Thanks in advance.

Anton Arapov <aarapov@redhat.com> writes:
> Hi!
>
>   SysV code returns EIDRM for collision of IDs. I sure it should return EINVAL.
>
>   Steps to reproduce: (this for shared memory code, for msg/sem it is the same)
>    1. Create then drop 2 shmem segments, then create a third.
>    2. Try to shmctl(IPC_STAT) the two now-invalid shm IDs.
>    3. Note error codes returned.
>
>    One call gives EINVAL, one gives EIDRM due to collision with the third shmem segment.
>    Should both give EINVAL, this is what I've got on every other Unix I've tried it on. 
>
>   IPC code is good, EIDRM is justification of EINVAL. But neither SVr4 nor SVID documents EIDRM. 
>   Single Unix Specification mentions EINVAL but not EIDRM as a possible failure for shmctl(), so the current kernel behavior is not merely self-inconsistent but a flat violation of the spec. 
>
>   Can somebody explain why do we have EIDRM?
>
> Anton.
> SUS: http://www.opengroup.org/onlinepubs/007908799/xsh/shmctl.html
