Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZLNT6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZLNT6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbZLNT6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:58:13 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44755 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499AbZLNT6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:58:08 -0500
Date: Mon, 14 Dec 2009 20:58:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] laptop-mode: Make flushes per-device
Message-ID: <20091214195806.GV8742@kernel.dk>
References: <20091214190827.GS8742@kernel.dk> <1260820118-2200-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260820118-2200-1-git-send-email-mjg@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14 2009, Matthew Garrett wrote:
> One of the features of laptop-mode is that it forces a writeout of dirty
> pages if something else triggers a physical read or write from a device.
> The current implementation flushes pages on all devices, rather than only
> the one that triggered the flush. This patch alters the behaviour so that
> only the recently accessed block device is flushed, preventing other
> disks being spun up for no terribly good reason.

A few comments... Perhaps the timer deletion should go into the backing,
since that is where it's sitting?

Also, I think it would be cleaner to queue the flush work from the timer
on the per-bdi thread, instead of having a work struct allocated and
using that work item to simply call bdi writeback instead.

-- 
Jens Axboe

