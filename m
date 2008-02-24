Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYBXS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYBXS1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYBXS1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:27:11 -0500
Received: from mail2.shareable.org ([80.68.89.115]:51271 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYBXS1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:27:10 -0500
X-Greylist: delayed 1851 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 13:27:10 EST
Date: Sun, 24 Feb 2008 16:11:35 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: jffs2: -ENOSPC when truncating file?!
Message-ID: <20080224161135.GA4918@shareable.org>
References: <20080223235742.GE2202@elf.ucw.cz> <1203813368.5771.174.camel@shinybook.infradead.org> <20080224072423.GF2202@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224072423.GF2202@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> > You need to write a log entry indicating the new length of the file.
> > There is no space for new log entries.
> > 
> > There is a special case for removal -- 'rm gps.nmea' would work. Perhaps
> > we should add a special case for truncation too, so that it can also use
> > the extra pool of free space.
> 
> Yes, that would be nice. I somehow assumed that truncate can't fail
> for -ENOSPC ... I was trying to actually free some space on the
> filesystem...

Same here!  When I got ENOSPC from truncate, trying to free some
space, I was so surprised (and a bit disappointed) that I assumed
removal could fail too.  So now I'm pleasantly surprised to learn I
can at least remove a file.

It does seem odd that truncate to zero length can fail.  It is
guaranteed to free up one or more data nodes, so there should be
enough space for the size change node, provided GC is invoked when
necessary and the node sizes are compatible for this in corner cases.

-- Jamie
