Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZJZPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZJZPpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZJZPpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZJZPpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:45:42 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 5/5] cfq-iosched: fairness for sync no-idle queues
References: <200910202012.43338.czoccolo@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Oct 2009 11:45:34 -0400
In-Reply-To: <200910202012.43338.czoccolo@gmail.com> (Corrado Zoccolo's
	message of "Tue, 20 Oct 2009 20:12:43 +0200")
Message-ID: <x49k4yixiox.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> +static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
> +{
> +	if (!cfq_cfqq_sync(cfqq))
> +		return ASYNC_WORKLOAD;
> +	if (CFQQ_SEEKY(cfqq) || !cfq_cfqq_idle_window(cfqq))
> +		return SYNC_NOIDLE_WORKLOAD;
> +	return SYNC_WORKLOAD;
> +}

The calculation to determine whether or not to idle is now done in at
least 2 places.  Perhaps it's time for a helper function.

There are some other coding style nits, but I'll let Jens comment on
those.  I think the idea looks good.  Once you rebase I'll run some
tests; this is some really good work!

Cheers,
Jeff
