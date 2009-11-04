Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZKDLan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZKDLan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZKDLam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:30:42 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:17515 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbZKDLal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hkM8szuxXxcI+KK44ucWipEVbQUZtOWQE7YL1GkRRhoSIbRkU66lLoyFD4d1Mf2PFp
         mjY+KR0UH145XRU1s4AlocTKpHP/VFk2j19FpE8aVUNpHSXnXGAuaU9x44eB+Ca1o/+4
         +r+vvTWrH1B4O2BWBTkyB+vO7SvbkU57msffk=
Subject: Re: [PATCH] mm/ksm.c - Fix compile warnings (PS ignore my
 formatting in previous email)
From: askb <askb23@gmail.com>
To: wharms@bfs.de
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <4AF15022.1020408@bfs.de>
References: <1257317010.14838.55.camel@linux-k65f.site>
	 <4AF15022.1020408@bfs.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 16:58:59 +0530
Message-Id: <1257334139.14838.264.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 10:57 +0100, walter harms wrote:
> 
> askb schrieb:
> > Found the compiler warning on linux-next: 	
> > 
> > mm/ksm.c: In function ‘ksm_scan_thread’:
> > mm/ksm.c:1083: warning: ‘page2[0u]’ may be used uninitialized in this
> > function
> > mm/ksm.c:1083: note: ‘page2[0u]’ was declared here
> > 
> > fix for the above warning:
> > 
> > Signed-off-by: Anil SB <askb23@gmail.com>
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index bef1af4..2ea0fd3 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -1080,7 +1080,7 @@ static void stable_tree_append(struct rmap_item *rmap_item,
> >   */
> >  static void cmp_and_merge_page(struct page *page, struct rmap_item *rmap_item)
> >  {
> > -	struct page *page2[1];
> > +	struct page *page2[1] = {NULL};
> >  	struct rmap_item *tree_rmap_item;
> >  	unsigned int checksum;
> >  	int err;
> > 
> > 
> 
> a 1 element array looks strange, did you look what kind of magic is here used ?
> 
>From my understanding, it is used for place holder to check and return
an identical page from stable_tree_search(). Can we do with a double
indirection to struct page instead of the above? 
PS point me in the right direction.

Regards.

