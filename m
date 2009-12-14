Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbZLNUyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbZLNUyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbZLNUye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:54:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44162 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbZLNUye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:54:34 -0500
Date: Mon, 14 Dec 2009 20:54:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] laptop-mode: Make flushes per-device
Message-ID: <20091214205428.GA8917@srcf.ucam.org>
References: <20091214190827.GS8742@kernel.dk> <1260820118-2200-1-git-send-email-mjg@redhat.com> <20091214195806.GV8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214195806.GV8742@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 08:58:06PM +0100, Jens Axboe wrote:
> On Mon, Dec 14 2009, Matthew Garrett wrote:
> > One of the features of laptop-mode is that it forces a writeout of dirty
> > pages if something else triggers a physical read or write from a device.
> > The current implementation flushes pages on all devices, rather than only
> > the one that triggered the flush. This patch alters the behaviour so that
> > only the recently accessed block device is flushed, preventing other
> > disks being spun up for no terribly good reason.
> 
> A few comments... Perhaps the timer deletion should go into the backing,
> since that is where it's sitting?

That was for symmetry with the setup, but I'm not married to it.

> Also, I think it would be cleaner to queue the flush work from the timer
> on the per-bdi thread, instead of having a work struct allocated and
> using that work item to simply call bdi writeback instead.

I had a vague recollection of context awkwardness, but I may have been 
wrong there. I'll try that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
