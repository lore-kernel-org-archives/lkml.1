Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZLLMYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZLLMYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 07:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZLLMYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 07:24:38 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46099 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZLLMYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 07:24:38 -0500
Date: Sat, 12 Dec 2009 13:24:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] laptop-mode: Make flushes per-device
Message-ID: <20091212122443.GA8742@kernel.dk>
References: <20091211164433.GA1980@srcf.ucam.org> <1260554071-2190-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260554071-2190-1-git-send-email-mjg@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11 2009, Matthew Garrett wrote:
> One of the features of laptop-mode is that it forces a writeout of dirty
> pages if something else triggers a physical read or write from a device.
> The current implementation flushes pages on all devices, rather than only
> the one that triggered the flush. This patch alters the behaviour so that
> only the recently accessed block device is flushed, preventing other
> disks being spun up for no terribly good reason.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
> 
> The forward struct declaration in writeback.h seems messy, but I'm not
> sure there's a cleaner way to do this. I'm also still woefully
> unfamiliar with the block layer - I /think/ this does the right thing,
> but some review would be nice.

That's because it is messy, why are you passing the request in? It
would be a lot more sane to pass in the queue, better still the backing
device.

What guarentees that the timer isn't running when the bdi goes away?

-- 
Jens Axboe

