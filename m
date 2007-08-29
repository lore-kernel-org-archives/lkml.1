Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbXH2TH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbXH2TH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbXH2THO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:07:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41574 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbXH2THM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:07:12 -0400
Date: Wed, 29 Aug 2007 20:07:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [patch 1/4] Introduce pathput
Message-ID: <20070829190710.GA28028@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de> <20070808193209.GA31354@infradead.org> <20070810142208.827949199@suse.de> <20070810143846.804017666@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810143846.804017666@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 04:22:09PM +0200, Andreas Gruenbacher wrote:
> * Add pathput() for releasing a reference to the dentry and vfsmount of a
>   struct path.
> 
> * Switch from path_release(nd) to pathget(&nd->path).

				^^^^^^^^^^^^^ pathput

> 
> * Switch from path_release_on_umount(nd) to pathput_on_umount(&nd->path).
> 
> * Rename dput_path() to pathput_conditional().

The introduction of pathput is fine we me.  The removal of path_release
doesn't make much sense.  We have tons of invocations of exactly that
patter, and having keeping path_release for that makes a lot of sense.

I also think there rename from dput_path to pathput_conditional is
rather pointless.  Sure, that thing needs a better name, but
pathput_conditional is not a better name.

And all of the functions could use some kerneldoc comments describing them.
