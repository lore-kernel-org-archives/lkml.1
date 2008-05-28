Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYE1OWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYE1OWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYE1OWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:22:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYE1OWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:22:41 -0400
Date: Wed, 28 May 2008 09:43:24 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH -mm 07/16] second chance replacement for anonymous pages
Message-ID: <20080528094324.39f625a8@bree.surriel.com>
In-Reply-To: <20080528195925.9CD3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080523195506.084894989@redhat.com>
	<20080523195535.302440037@redhat.com>
	<20080528195925.9CD3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 20:03:11 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > @@ -1129,7 +1141,11 @@ static unsigned long shrink_list(enum lr
> >  {
> >  	int file = is_file_lru(lru);
> >  
> > -	if (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE) {
> > +	if (lru == LRU_ACTIVE_FILE) {
> > +		shrink_active_list(nr_to_scan, zone, sc, priority, file);
> > +		return 0;
> > +	}
> > +	if (lru == LRU_ACTIVE_ANON && inactive_anon_low(zone)) {
> >  		shrink_active_list(nr_to_scan, zone, sc, priority, file);
> >  		return 0;
> >  	}
> 
> I made memcgroup noreclaim infrastructure today.
> and, I found slightly odd behaviour.
> 
> this condition increase OOM, because prevent active -> inactive moving 
> even though non global reclaim.

Good catch, I have applied your patch to my tree.

-- 
All rights reversed.
