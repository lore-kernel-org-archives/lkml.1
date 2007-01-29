Return-Path: <linux-kernel-owner+w=401wt.eu-S1751171AbXA2SCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbXA2SCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXA2SCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:02:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33362 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXA2SCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:02:48 -0500
Date: Mon, 29 Jan 2007 18:02:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070129180233.GA17754@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
	Eric Paris <eparis@parisplace.org>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128151122.GA21159@infradead.org> <1170077573.8720.30.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170077573.8720.30.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 08:32:53AM -0500, Stephen Smalley wrote:
> >  - fs/selinuxfs.c:sel_remove_bools()
> > 
> > 	Utter madness.  I have no idea how this ever got merged.
> > 	Maybe the selinux folks can explain what crack they were
> > 	on when writing this.  The problem would go away with
> > 	a generic rewoke infrastructure.
> 
> It was modeled after proc_kill_inodes(), as noted in the comments.  So
> if you have a suitable replacement for proc_kill_inodes(), you can apply
> the same approach to sel_remove_bools().

Looking at it again sel_remove_bools actually only operates on files
backed by selinuxfs, so yes we could use the same approach.
