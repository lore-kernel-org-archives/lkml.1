Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZLBPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZLBPNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZLBPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:13:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZLBPNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:13:17 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] cfq-iosched: fix corner cases in idling logic
References: <200911241449.36336.czoccolo@gmail.com>
	<x49zl61lcg8.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0912020614r7352727an62f441e191ae6609@mail.gmail.com>
	<20091202143808.GB31715@redhat.com>
	<x49638pl9eo.fsf@segfault.boston.devel.redhat.com>
	<20091202150234.GC31715@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Dec 2009 10:13:17 -0500
In-Reply-To: <20091202150234.GC31715@redhat.com> (Vivek Goyal's message of
	"Wed, 2 Dec 2009 10:02:34 -0500")
Message-ID: <x49tyw9if3m.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Does it make a big difference. cfq_close_cooperator() does not seem to be
> relying on coop flag. It will return us a queue if it thinks there is a
> close cooperator. (Irrespective of the fact whether cfqq->new_cfqq has bee
> setup yet or not). IIUC, cfqq->new_cfqq will be set in select_queue(). So
> in case select_queue() has not run yet, then cfqq->new_cfqq = NULL but we
> have a close cooperator.
>
> But I guess this condition will not hit many a times as select_queue()
> happens very frequently on NCQ hardware and the moment select queue finds
> close cooperator it will expire the current queue and above check will not
> even get a chance to turn.
>
> So IIUC, if we are here cfqq->new_cfqq is always NULL otherwise select_queue()
> by now must have expired us and we will not be here. So either we can
> completely remove the check or we can just continue with above check.

Wow, I need another cup of coffee for sure.  You can just ignore me as I
completely misread the code being changed.

Sorry for the noise.  I'll go make some coffee.

Cheers,
Jeff
