Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbYDYHSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbYDYHSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYDYHS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:18:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26638 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYDYHS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:18:29 -0400
Date: Fri, 25 Apr 2008 09:18:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080425071823.GF12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-2-git-send-email-jens.axboe@oracle.com> <20080424220157.GA26179@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424220157.GA26179@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24 2008, Russell King wrote:
> On Tue, Apr 22, 2008 at 08:50:17PM +0200, Jens Axboe wrote:
> > +		data->csd.func(data->csd.info);
> > +
> > +		spin_lock(&data->lock);
> > +		cpu_clear(cpu, data->cpumask);
> > +		WARN_ON(data->refs == 0);
> > +		data->refs--;
> > +		refs = data->refs;
> 
> Probably a silly question, but what does data->refs do that
> cpus_empty(data->cpumask) wouldn't do?  (as indeed ARM presently does.)

I guess it can be marginally slower for NR_CPUS > BITS_PER_LONG,
otherwise there's absolutely no reason to have a seperate ref counter.

-- 
Jens Axboe

