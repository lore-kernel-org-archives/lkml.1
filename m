Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZJZPGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZJZPGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZJZPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbZJZPGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:06:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: jens.axboe@oracle.com, Linux Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [patch,rfc] cfq: merge cooperating cfq_queues
References: <x49d44hx6uu.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910211433o670baec9o5a51dbfcbdcec936@mail.gmail.com>
	<x49ljj470ig.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910220145t300fe3fbo6ca7b623214d0a20@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Oct 2009 11:06:01 -0400
In-Reply-To: <4e5e476b0910220145t300fe3fbo6ca7b623214d0a20@mail.gmail.com>
	(Corrado Zoccolo's message of "Thu, 22 Oct 2009 10:45:34 +0200")
Message-ID: <x4963a2yz3a.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi
> On Thu, Oct 22, 2009 at 2:09 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> I think it's wrong to call the userspace programs broken.  They worked
>> fine when CFQ was quantum based, and they work well with noop and
>> deadline.
>
> So they didn't work well with anticipatory, that was the default from
> 2.6.0 to 2.6.17, and with CFQ with time slices, that was the default
> from 2.6.18 up to now.  I think enough time has passed to start fixing
> those programs.

I actually didn't test anticipatory, so I'm not sure about that one.

> I think fixing nfsd at least for TCP should be easy. In TCP case, each
> client has a private thread pool, so you can just share the I/O
> context once, when creating those threads, and forget it.

I don't think it's a thread pool per client.  Where did you get that
impression?  Simply changing nfsd to use a single I/O context may be an
approachable solution to the problem.  I'm not sure if it's optimal, but
it has to be better than what we have today.

> For the UDP case, would just reducing idle window fix the problem? Or
> the problem is not really the idling, but the bad I/O pattern?

I think the two cases can be handled the same way.  I'll look into it if
time permits.

Cheers,
Jeff
