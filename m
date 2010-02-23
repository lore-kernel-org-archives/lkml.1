Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0BWOo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:44:29 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59449 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0BWOo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:44:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NhvKzsuUouNlTOpomHpYJDN6+zE06R4f0b/0xGmHt+kGrqvBqZVpm0yV8IrE4d73kT
         VcIfrQSovQmKjfdPmxxhTzPdfe7Qb4qJj5hTAXd/1oWtZLjFWR+mwa+zvVB1tGoNudV4
         BAv+ysPetm2hJWhqUi9lGsxXdU5kh+1jLAub4=
Subject: Re: [patch 1/3] vmscan: factor out page reference checks
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100223142158.GA29762@cmpxchg.org>
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org>
	 <1266868150-25984-2-git-send-email-hannes@cmpxchg.org>
	 <1266932303.2723.13.camel@barrios-desktop>
	 <20100223142158.GA29762@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 23:44:14 +0900
Message-ID: <1266936254.2723.33.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 15:21 +0100, Johannes Weiner wrote:
> Hello Minchan,
> 
> On Tue, Feb 23, 2010 at 10:38:23PM +0900, Minchan Kim wrote:

<snip>

> > >  
> > >  		if (PageDirty(page)) {
> > > -			if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
> > > +			if (references == PAGEREF_RECLAIM_CLEAN)
> > 
> > How equal PAGEREF_RECLAIM_CLEAN and sc->order <= PAGE_ALLOC_COSTLY_ORDER
> > && referenced by semantic?
> 
> It is encoded in page_check_references().  When
> 	sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced
> it returns PAGEREF_RECLAIM_CLEAN.
> 
> So
> 
> 	- PageDirty() && order < COSTLY && referenced
> 	+ PageDirty() && references == PAGEREF_RECLAIM_CLEAN
> 
> is an equivalent transformation.  Does this answer your question?

Hmm. I knew it. My point was PAGEREF_RECLAIM_CLEAN seems to be a little
awkward. I thought PAGEREF_RECLAIM_CLEAN means if the page was clean, it
can be reclaimed.

I think it would be better to rename it with represent "Although it's
referenced page recently, we can reclaim it if VM try to reclaim high
order page".


> 
> 	Hannes


-- 
Kind regards,
Minchan Kim


