Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYE1NkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYE1NkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYE1Njw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:39:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbYE1Njw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:39:52 -0400
Date: Wed, 28 May 2008 09:39:18 -0400
From: Rik van Riel <riel@redhat.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 07/16] second chance replacement for anonymous pages
Message-ID: <20080528093918.37660860@bree.surriel.com>
In-Reply-To: <483CEF78.9050802@mxp.nes.nec.co.jp>
References: <20080523195506.084894989@redhat.com>
	<20080523195535.302440037@redhat.com>
	<483CEF78.9050802@mxp.nes.nec.co.jp>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 14:36:56 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> >  	/*
> > +	 * Count the referenced anon pages as rotated, to balance pageout
> > +	 * scan pressure between file and anonymous pages in get_sacn_ratio.
> > +	 */
> > +	if (!file)
> > +		zone->recent_rotated_anon += pgmoved;
> > +
> 
> Shouldn't 'pgmoved' be cleared to 0 before scanning l_hold?
> It's used to store the result of sc->isolate_pages() before
> scanning l_hold.

It is zeroed 2 statements down.

        if (!file)
                zone->recent_rotated_anon += pgmoved;

        /*
         * Now put the pages back on the appropriate [file or anon] inactive
         * and active lists.
         */
        pagevec_init(&pvec, 1);
        pgmoved = 0;

-- 
All rights reversed.
