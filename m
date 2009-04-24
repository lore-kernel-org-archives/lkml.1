Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZDXHnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZDXHnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZDXHng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:43:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41466 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZDXHnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:43:35 -0400
Date: Fri, 24 Apr 2009 09:43:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-2.6-block/for-linus] Fix discard requests
	accounting in the diskstats
Message-ID: <20090424074334.GC4593@kernel.dk>
References: <200904232013.n3NKD4PP017241@imap1.linux-foundation.org> <200904241118.30919.knikanth@suse.de> <20090424061518.GY4593@kernel.dk> <200904241308.35738.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904241308.35738.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24 2009, Nikanth Karthikesan wrote:
> On Friday 24 April 2009 11:45:18 Jens Axboe wrote:
> > On Fri, Apr 24 2009, Nikanth Karthikesan wrote:
> > > When 2 discard requests are merged, the stats gets updated, but we do not
> > > update statistics normally when a discard request is issued or completed.
> > > For example the in_flight counter would be decremented when 2 discard
> > > requests are merged, but it was not at all incremented when they were
> > > issued, and in_flight counter will not be decremented, when they are
> > > completed as well.
> > >
> > > This patch fixes this by adding discard requests to the statistics.
> > >
> > > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >
> > OK, so that's not quite what I had in mind. If we first do this as a
> > preparatory patch:
> >
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=42fd769da4edadad83a7
> >79867ff1910ec35c6de7
> >
> 
> Oh! I thought this cleanup along with the 
> block-turn-some-buggy-macros-into-c-functions.patch from Andrew could be done 
> on top of my original fix. But didn't, as you said, you would do it. Anyway, 
> Thanks.

Refactor and then fix is the cleanest I think. Anyway, queued up for
2.6.31!

-- 
Jens Axboe

