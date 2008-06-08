Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYFHPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYFHPNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYFHPNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:13:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbYFHPNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:13:05 -0400
Date: Sun, 8 Jun 2008 11:11:48 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 08/25] add some sanity checks to get_scan_ratio
Message-ID: <20080608111148.21ef0bfb@bree.surriel.com>
In-Reply-To: <20080606180447.5487a6e8.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.807500425@redhat.com>
	<20080606180447.5487a6e8.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:04:47 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	if (unlikely(zone->recent_scanned_file > file / 4)) {
> 
> I see nothing in the changelog about this and there are no comments. 
> How can a reader possibly work out what you were thinking when this
> was typed in??

Pulled into the main split LRU patch and commented.
 
> Perhaps the (nr_swap_pages <= 0) test could happen earlier on.

Done.
 
> Please quadruple-check this code like a paranoid maniac looking for
> underflows, overflows and divides-by-zero.  Bear in mind that x/(y+1)
> can get a div-by-zero for sufficiently-unepected values of y.

Done that already.

> Oh, so that's what the [0] and [1] in get_scan_ratio() mean.  Perhaps
> doing this:
> 
> 	if (nr_swap_pages <= 0) {
> 		percent[0] = 0;		/* anon */
> 		percent[1] = 100;	/* file */
> 
> would clarify things. 

Added lots of comments on this.

> > +++ linux-2.6.26-rc2-mm1/include/linux/mmzone.h	2008-05-28 12:11:51.000000000 -0400
> > @@ -289,6 +289,8 @@ struct zone {
> >  
> >  	unsigned long		recent_rotated_anon;
> >  	unsigned long		recent_rotated_file;
> > +	unsigned long		recent_scanned_anon;
> > +	unsigned long		recent_scanned_file;
> 
> I think struct zone is sufficiently important and obscure that
> field-by-field /*documentation*/ is needed.  Not as kerneldoc, please -
> better to do it at the definition site

Added documentation for these.

-- 
All rights reversed.
