Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbXKUOOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbXKUOOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXKUON7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:13:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36233 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXKUON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:13:59 -0500
Date: Wed, 21 Nov 2007 14:13:47 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Christoph Hellwig <hch@infradead.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       devel@openvz.org, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [patch 1/1] selinux:  do not clear f_op when removing entries
Message-ID: <20071121141347.GA5695@infradead.org>
References: <20071116150651.GC19517@localhost.sw.ru> <20071119125139.GB15942@infradead.org> <1195571105.20910.31.camel@moss-spartans.epoch.ncsc.mil> <20071120151731.GA20322@infradead.org> <1195653696.759.29.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195653696.759.29.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 09:01:36AM -0500, Stephen Smalley wrote:
> Do not clear f_op when removing entries since it isn't safe to do.

If this is still safe for selinux I'm fine with it.  It also gets rid
of one of them few remaining s_files users which is always good.

Btw, after this patch we should be able to kill all places that check
for a non-zero file->f_op because it should never be non-zero.  Of course
we'll need an actual audit first to make sure nothing has been slipping
through.
