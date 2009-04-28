Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbZD1L74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbZD1L74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbZD1L7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:59:44 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:34528 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZD1L7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:59:42 -0400
Subject: Re: NFS BUG_ON in nfs_do_writepage
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Rince <rincebrain@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <20090428115449.GD9442@wotan.suse.de>
References: <5da0588e0904131506k5c58e8ddob9bf38f61da6302a@mail.gmail.com>
	 <5da0588e0904131644g131dc816r61884e83bc4cd006@mail.gmail.com>
	 <5da0588e0904240226j3454941y5f58c17a32a9a23d@mail.gmail.com>
	 <1240671428.6112.1.camel@heimdal.trondhjem.org>
	 <20090426064026.GD28555@wotan.suse.de>
	 <1240755509.5055.34.camel@heimdal.trondhjem.org>
	 <20090426151324.GB5588@wotan.suse.de>
	 <1240768522.10548.33.camel@heimdal.trondhjem.org>
	 <20090428042717.GA6304@wotan.suse.de>
	 <1240919117.7376.6.camel@heimdal.trondhjem.org>
	 <20090428115449.GD9442@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 07:59:38 -0400
Message-Id: <1240919978.7376.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 2 sum rcpts/h 15 sum msgs/h 3 total rcpts 87 max rcpts/h 12 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: 2964133422AD68F2FC01B002E2010DC64BC63C44
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 208 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 13:54 +0200, Nick Piggin wrote:
> If the page gets cleaned after page_mkwrite and before the page
> table locks are taken again in order to set the pte writeable.
> (actually, page_mkclean only runs if it finds mapcount elevated,
> so it is enough to clean the page even after the locks are taken
> and before mapcount is incremented in the case of __do_fault).

OK. This was what I was missing...

Thanks!

