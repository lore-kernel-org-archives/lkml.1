Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYBXK5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYBXK5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYBXK5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:57:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbYBXK5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:57:38 -0500
Subject: Re: jffs2: -ENOSPC when truncating file?!
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-mtd@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080224065751.GA31293@lazybastard.org>
References: <20080223235742.GE2202@elf.ucw.cz>
	 <1203813368.5771.174.camel@shinybook.infradead.org>
	 <20080224065751.GA31293@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 24 Feb 2008 18:57:32 +0800
Message-Id: <1203850653.13749.9.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 07:57 +0100, Jörn Engel wrote:
> Could a naïve implementation of this get exploited by doing a large
> number of truncates that just shave single bytes off various files?

Yeah, which is why _my_ naïve implementation would do it for
truncate-to-zero instead of just _any_ truncate (which could even be
truncate-to-larger).

A more complex version might allow _any_ transaction to eat into the
ALLOC_DELETION pool if it is ultimately going to reduce the amount of
space taken on the file system -- even overwriting 'real' data with
zeroes which compress better. That's going to be hard to calculate in
the general case though.

If allowing only truncate-to-zero isn't good enough, perhaps we could
allow truncation to use the ALLOC_DELETION pool when it's going to
obsolete at least one full data node. That's not so hard to check.

-- 
dwmw2

