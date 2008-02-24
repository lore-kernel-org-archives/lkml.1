Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYBXTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYBXTBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYBXTBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:01:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35740 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753095AbYBXTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:01:45 -0500
Date: Sun, 24 Feb 2008 20:02:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-mtd@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: jffs2: -ENOSPC when truncating file?!
Message-ID: <20080224190207.GA18908@elf.ucw.cz>
References: <20080223235742.GE2202@elf.ucw.cz> <1203813368.5771.174.camel@shinybook.infradead.org> <20080224065751.GA31293@lazybastard.org> <1203850653.13749.9.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1203850653.13749.9.camel@shinybook.infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-02-24 18:57:32, David Woodhouse wrote:
> 
> On Sun, 2008-02-24 at 07:57 +0100, Jörn Engel wrote:
> > Could a na??ve implementation of this get exploited by doing a large
> > number of truncates that just shave single bytes off various files?
> 
> Yeah, which is why _my_ na??ve implementation would do it for
> truncate-to-zero instead of just _any_ truncate (which could even be
> truncate-to-larger).
> 
> A more complex version might allow _any_ transaction to eat into the
> ALLOC_DELETION pool if it is ultimately going to reduce the amount of
> space taken on the file system -- even overwriting 'real' data with
> zeroes which compress better. That's going to be hard to calculate in
> the general case though.
> 
> If allowing only truncate-to-zero isn't good enough, perhaps we could
> allow truncation to use the ALLOC_DELETION pool when it's going to
> obsolete at least one full data node. That's not so hard to check.

I believe truncate-to-zero is good enough.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
