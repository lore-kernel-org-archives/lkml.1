Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYFYQUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYFYQUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbYFYQTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:19:50 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56864 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbYFYQTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:19:49 -0400
Date: Wed, 25 Jun 2008 20:19:15 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Message-ID: <20080625161914.GB20236@2ka.mipt.ru>
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <20080625131117.GA28136@2ka.mipt.ru> <E1KBV7H-0005nv-Gl@pomaz-ex.szeredi.hu> <20080625141654.GA4803@2ka.mipt.ru> <E1KBWBK-0006Lp-03@pomaz-ex.szeredi.hu> <20080625154713.GA18682@2ka.mipt.ru> <E1KBXSF-00076u-7Y@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KBXSF-00076u-7Y@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 06:02:43PM +0200, Miklos Szeredi (miklos@szeredi.hu) wrote:
> > I do not know fuse good enough, but it looks like if your patch only
> > fixes issue for pages which are in splice buffer during invalidation,
> > any subsequent call for splice() will get correct new data (at least
> > invoke readpage(s)), but in the description of error there was a
> > long timeout between reading and writing, so it was a fresh splice()
> > call, which suddenly started to return errors.
> > 
> > Is it possible that by having uptodate bit in place, but page was
> > actually freed but not removed from all trees and so on, so it
> > masked read errors? This may be not the right conclusion though :)
> 
> No, the mechanics of the problem are well understood.  Only the
> solution is problematic :)

Then why not fix filesystems to set error bit on all broken reads, if
you sure it is the case?

-- 
	Evgeniy Polyakov
