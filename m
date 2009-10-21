Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZJUQgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZJUQgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZJUQgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:36:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbZJUQgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:36:51 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 1/5] cfq-iosched: adapt slice to number of  processes doing I/O
References: <200910202011.53858.czoccolo@gmail.com>
	<x49aazk91uj.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910210932l2dffdabdv67a449ca162efd0f@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Oct 2009 12:36:49 -0400
In-Reply-To: <4e5e476b0910210932l2dffdabdv67a449ca162efd0f@mail.gmail.com>
	(Corrado Zoccolo's message of "Wed, 21 Oct 2009 18:32:37 +0200")
Message-ID: <x49tyxs7lge.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

>> Couldn't you have just divided the slice by iq?  And why iq?  Why not
>> nr_qs or avg_qlen or something?  It's a minor nit; I can live with it.
>
> iq stands for interested queues, because we are restricting the count
> just to the same priority class, not all queues in the system.

Ah, that makes sense.  A comment would make that clear.

> I don't think this is equivalent. You seem to compute some divisions
> too early, losing in precision.

OK, I figured as much.

> slice * cfq_target_latency / (cfqd->cfq_slice[1] * iq)
> is not generally equivalent to:
> slice * (cfq_target_latency / (cfqd->cfq_slice[1] * iq))
> that is what you are computing.
> There is an other such case in your simplification.

OK.  The idea was to try to make the thing a bit more digestable.
Honestly, I had to re-write it to figure out what it was doing.  Could
you rework it so the logic is more obvious to others and still correct?

Thanks!
Jeff
