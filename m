Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYBRPtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYBRPtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYBRPtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:49:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYBRPtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:49:03 -0500
Date: Mon, 18 Feb 2008 10:48:56 -0500
From: Rik van Riel <riel@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem with /proc/sys/vm/lowmem_reserve_ratio ???
Message-ID: <20080218104856.053e7682@bree.surriel.com>
In-Reply-To: <x49wsp272se.fsf@segfault.boston.devel.redhat.com>
References: <47B5A699.7010509@redhat.com>
	<x49wsp272se.fsf@segfault.boston.devel.redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 09:33:05 -0500
Jeff Moyer <jmoyer@redhat.com> wrote:

> Larry Woodman <lwoodman@redhat.com> writes:
> 
> > balance_pgdat() calls zone_watermark_ok() three times, the first call
> > passes a zero(0) in as the 4th argument.  This 4th argument is the
> > classzone_idx which is used as the index into the
> > zone->lowmem_reserve[] array.  Since setup_per_zone_lowmem_reserve()
> > always sets the zone->lowmem_reserve[0] = 0(because there is nothing
> > below the DMA zone), zone_watermark_ok() will not consider the
> > lowmem_reserve pages when zero is passed as the 4th arg.  Shouldnt this
> > 4th argument be either "i" or "nr_zones - 1" ???
> 
> That certainly looks like the intent of this code.  I'd say patch 1,
> passing i in as the 4th arg.  Rik, what do you think?

Yes, that is probably the best option.

-- 
All rights reversed.
