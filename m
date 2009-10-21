Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZJUQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZJUQMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbZJUQM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:12:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZJUQM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:12:28 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 4/5] cfq-iosched: enable idling for last queue on priority class
References: <200910202012.21469.czoccolo@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Oct 2009 12:12:27 -0400
In-Reply-To: <200910202012.21469.czoccolo@gmail.com> (Corrado Zoccolo's
	message of "Tue, 20 Oct 2009 20:12:21 +0200")
Message-ID: <x4963a8915g.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> cfq can disable idling for queues in various circumstances.
> When workloads of different priorities are competing, if the higher
> priority queue has idling disabled, lower priority queues may steal
> its disk share. For example, in a scenario with an RT process
> performing seeky reads vs a BE process performing sequential reads,
> on an NCQ enabled hardware, with low_latency unset,
> the RT process will dispatch only the few pending requests every full
> slice of service for the BE process.
>
> The patch solves this issue by always performing idle on the last
> queue at a given priority class > idle. If the same process, or one
> that can pre-empt it (so at the same priority or higher), submits a
> new request within the idle window, the lower priority queue won't
> dispatch, saving the disk bandwidth for higher priority ones.
>
> Note: this doesn't touch the non_rotational + NCQ case (no hardware
> to test if this is a benefit in that case).
>
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>

This looks OK at first glance.

Cheers,
Jeff
