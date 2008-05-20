Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbYETSku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbYETSku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYETSkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:40:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbYETSkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:40:41 -0400
Date: Tue, 20 May 2008 14:38:02 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, systemtap@sources.redhat.com
Subject: Re: [2.6 patch] unexport uts_sem
Message-ID: <20080520183802.GA686@redhat.com>
References: <20080505182937.GZ17139@cs181133002.pp.htv.fi> <y0mwsloq4kc.fsf@ton.toronto.redhat.com> <20080520172730.GA2361@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520172730.GA2361@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, May 20, 2008 at 01:27:30PM -0400, Christoph Hellwig wrote:
> > Am I correct that this would makes it invalid for modules to call
> > utsname() (since the protective semaphore is now hidden)?
> 
> Yesm they should never had done that anyway.  The module support
> does it's own version checking already.

Sorry, I misspoke - this check is intended not to cross-check
kernel-devel and the kernel itself, but the debuginfo or similar data
that is given to describe target of a systemtap script.  I guess for
new enough kernels we'll just do that using buildid hash codes.

By the way, there do appear to be a few suspect in-tree users of
utsname() without uts_sem locking (usb/storage/usb.c, cifs/connect.c,
char/random.cc, fs/lockd/clntproc.c, ...).  If these need to be fixed,
then wouldn't uts_sem need to come back exported?

- FChE
