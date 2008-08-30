Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYH3Nir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYH3Nir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 09:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYH3Nii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 09:38:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYH3Nii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 09:38:38 -0400
Date: Sat, 30 Aug 2008 09:38:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] utrace: ptrace cooperation
Message-ID: <20080830133834.GA17566@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220237.66B3D154233@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826220237.66B3D154233@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 03:02:37PM -0700, Roland McGrath wrote:
> 
> This adds the CONFIG_UTRACE_PTRACE option under CONFIG_UTRACE.
> When set, parts of ptrace are replaced so it uses the utrace
> facilities for noticing events, stopping and resuming threads.
> 
> This makes ptrace play nicely with other utrace-based things
> tracing the same threads.  It also makes all ptrace uses rely on
> some of the utrace code working right, even when you are not
> using any other utrace-based things.  So it's experimental and
> not real well proven yet.  But it's recommended if you enable
> CONFIG_UTRACE and want to try new utrace things.

I don't like this patch in it's current form.  Having two different ways
to do ptrace is a rather awkward thing and not very good for testing
coverage.  This should not be an option but required.  I'm not even sure
keeping a non-utrace version at all is a good idea. I'd rather set a
deadline for arch maintainers to convert everything to the generic
ptrace bits + regsets + tracehook and if they don't manage to do it by
then ptrace will be disabled for those who can't keep up.  Of course
this will need an announcement on linux-arch first, but it's much better
than a never ending phase of APIs in migration.
