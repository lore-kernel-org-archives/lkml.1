Return-Path: <linux-kernel-owner+w=401wt.eu-S1764995AbYDONhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764995AbYDONhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760030AbYDONhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:37:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759591AbYDONhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:37:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "rae l" <crquan@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: iowait stability regressed from kernel 2.6.22 under heavy load of multi-thread aio writing/reading
References: <91b13c310804110217g1d2c3ee4p69fee6fd43f4abd2@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 15 Apr 2008 09:37:03 -0400
In-Reply-To: <91b13c310804110217g1d2c3ee4p69fee6fd43f4abd2@mail.gmail.com>
	(rae l.'s message of "Fri, 11 Apr 2008 17:17:31 +0800")
Message-ID: <x49k5izme80.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"rae l" <crquan@gmail.com> writes:

> I found a problem with the vanilla kernel from 2.6.22 (include 23, 24):
>
> the situation is to test a customized linux distribution under heavy IO load:
> 1. the client process initiates tens of POSIX threads (using
> libpthread), each thread uses aio_write or aio_read(using librt)
> operating
>    on one small file, then close it and write another small file;
>    the whole objective is to get a maxium throughput of small files,
> by generating heavy aio stress on the system;
>
> I have tested the vanilla kernel 2.6.22/23/24.y, all these kernels
> have the common problem:
> 1. I use top, vmstat, and iostat to monitor the system performance, I
> found that the iowait time of CPU is high at most time,
>    above 60%, and not stable while the client process running,
> although the throughput is stable, the CPU iowait time not stable;
>    As a result of instability processes felt too long and unacceptable delay.
> 2. in seldom testing cases, the system even stopped: with bi/bo are 0
> and iowait 100%, all writing processes are blocking with
>    uninterruptible state (D state in ps output), these cases are all
> system running after several days writing, but cannot guarantee
>    to reproduce;
>
> First I suspect the filesystem or the storage medium have problems, I
> tried ext2/ext3/reiserfs/xfs, for different filesytems and
> SATA/SAS, IDE disks, and several commercial hard RAID card for
> different storage medium, but the bad result remained;
>
> Then I tested 2.6.21.7 kernel, this results a stable iowait CPU time
> (below 10%) but not so good throughput of small files;
>
> Now I think the improvements of IO effciency in the development of
> 2.6.22 also caused the instability of iowait time, right? but how
> to find out? Simple bisecting seems not work.

Why doesn't bisecting work?  Can you provide your test code so others
can verify your findings?

> by the way, a question is how to guarantee a kernel not regress under
> heavy multi-thread aio writing load? ltp project seems not give the
> answer:

Well, providing your test code would be a step closer to achieving this
guarantee.  If it is scriptable, then there is a chance we could
integrate it into the aio-dio regression test suite:

  http://git.kernel.org/?p=linux/kernel/git/zab/aio-dio-regress.git;a=summary

Cheers,

Jeff
