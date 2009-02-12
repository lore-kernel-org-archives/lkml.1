Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZBLCaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZBLCaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZBLCaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:30:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:52620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZBLCaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:30:04 -0500
Date: Thu, 12 Feb 2009 03:30:02 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch] mm: vmap fix overflow
Message-ID: <20090212023002.GB23790@wotan.suse.de>
References: <20090210055119.GE28301@wotan.suse.de> <20090210144420.2e7bb9a9.akpm@linux-foundation.org> <20090212013931.GB30043@wotan.suse.de> <20090211182050.24425324.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211182050.24425324.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 06:20:50PM -0800, Andrew Morton wrote:
> On Thu, 12 Feb 2009 02:39:31 +0100 Nick Piggin <npiggin@suse.de> wrote:
> > 
> > Oh that's true, good catch. I guess that should be (addr + size - 1)?
> > Because we care about the last byte that was actually allocated to us
> > (inclusive, rather than exclusive).
> 
> That would work.  It wouldd give weird results for size==0, but probably
> that's already checked for somewhere(?)

It's checked down in __get_vm_area_node.

