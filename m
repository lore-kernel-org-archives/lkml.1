Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbZHZOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbZHZOut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZHZOus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZHZOur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:50:47 -0400
Date: Wed, 26 Aug 2009 15:50:45 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm snapshot: implement .iterate_devices
Message-ID: <20090826145045.GH643@agk-dp.fab.redhat.com>
Mail-Followup-To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 02:11:07AM -0400, Mike Snitzer wrote:
> This patch implements .iterate_devices for the origin and snapshot
> targets.  dm-snapshot's lack of .iterate_devices resulted in the
> inability to properly establish queue_limits for both targets.  
> With 4K sector drives: an unfortunate side-effect of not establishing
> proper limits in either targets' DM device was that IO to the devices
> would fail even though both had been created without error.
> Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 should have implemented
> .iterate_devices for dm-snap.c's origin and snapshot targets.
 
> +static int snapshot_iterate_devices(struct dm_target *ti,
> +				    iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_snapshot *snap = ti->private;
> +
> +	return fn(ti, snap->origin, 0, ti->len, data);
> +}

> +static int origin_iterate_devices(struct dm_target *ti,
> +				  iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_dev *dev = ti->private;
> +
> +	return fn(ti, dev, 0, ti->len, data);
> +}

Why are these both seemingly the same?  Is one sufficient?
And where are the characteristics of the 'cow' device taken into account?

Alasdair

