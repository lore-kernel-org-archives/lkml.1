Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbZDBUcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbZDBUcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbZDBUb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:31:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZDBUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:31:56 -0400
Date: Thu, 2 Apr 2009 16:31:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090402203152.GA16600@infradead.org>
References: <20090310143718.GB15977@wotan.suse.de> <1236809477.30142.83.camel@nimitz> <20090312041334.GB1893@wotan.suse.de> <1237403623.8286.196.camel@nimitz> <20090402182210.GB17175@wotan.suse.de> <1238697440.8846.46.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238697440.8846.46.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 11:37:20AM -0700, Dave Hansen wrote:
> > > Page faults themselves?  Which path was that from?
> > 
> > Yes. file_update_time.
> 
> We should be able to use your mnt_clone_write() optimization separate
> from the mnt_want_write() speedup here, right?  

Does file_update_time even need a separate mnt_want_write?  It should
always be after a mnt_want_write which we need for the actual data
write.

