Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXKTPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXKTPSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXKTPRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:17:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60549 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbXKTPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:17:40 -0500
Date: Tue, 20 Nov 2007 15:17:31 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Christoph Hellwig <hch@infradead.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       devel@openvz.org, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 1/4] proc: fix NULL ->i_fop oops
Message-ID: <20071120151731.GA20322@infradead.org>
References: <20071116150651.GC19517@localhost.sw.ru> <20071119125139.GB15942@infradead.org> <1195571105.20910.31.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195571105.20910.31.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 10:05:05AM -0500, Stephen Smalley wrote:
> > Nice, getting rid of this is a very good step formwards.  Unfortunately
> > we have another copy of this junk in
> > security/selinux/selinuxfs.c:sel_remove_entries() which would need the
> > same treatment.
> 
> Can't just be dropped completely for selinux - we need a way to drop
> obsolete entries from the prior policy when we load a new policy.
> 
> Is the only real problem here the clearing of f_op?  If so, we can
> likely remove that from sel_remove_entries() without harm, and fix the
> checks for it to use something more reliable.

f_op removal is the biggest issue.  It can't really work and this is the
last instance.  But in general having some half-backed attempts at revoke
is never a good idea.
