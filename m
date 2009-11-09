Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZKINrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZKINrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbZKINrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:47:41 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:38417 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbZKINrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:47:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YdycDz5tExQGHaCfhoKpRsvj+/74JAYokK6gUn/wHm2Xake+0f52Ll3uLpZZATIp9Z
         OdACBB64A6i9byliyQSzmiTv39ilCtgPy+I32BC8cykg35QLhOfUO9K5Rd+4RRN97VQd
         dVDYTvhjgId+WgJZhHnQhyfkXH4iMoRUZysYc=
Subject: Re: [PATCH] mm/ksm.c - Fix compile warnings (PS ignore my
 formatting in previous email)
From: askb <askb23@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: wharms@bfs.de, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0911091034120.15199@sister.anvils>
References: <1257317010.14838.55.camel@linux-k65f.site>
	 <4AF15022.1020408@bfs.de> <1257334139.14838.264.camel@linux-k65f.site>
	 <Pine.LNX.4.64.0911091034120.15199@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 19:15:31 +0530
Message-Id: <1257774331.5381.70.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 10:51 +0000, Hugh Dickins wrote:
> On Wed, 4 Nov 2009, askb wrote:
> > On Wed, 2009-11-04 at 10:57 +0100, walter harms wrote:
> > > 
> > > askb schrieb:
> > > > Found the compiler warning on linux-next: 	
> > > > 
> > > > mm/ksm.c: In function ‘ksm_scan_thread’:
> > > > mm/ksm.c:1083: warning: ‘page2[0u]’ may be used uninitialized in this
> > > > function
> > > > mm/ksm.c:1083: note: ‘page2[0u]’ was declared here
> > > > 
> > > > fix for the above warning:
> > > > 
> > > > Signed-off-by: Anil SB <askb23@gmail.com>
> > > > 
> > > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > > index bef1af4..2ea0fd3 100644
> > > > --- a/mm/ksm.c
> > > > +++ b/mm/ksm.c
> > > > @@ -1080,7 +1080,7 @@ static void stable_tree_append(struct rmap_item *rmap_item,
> > > >   */
> > > >  static void cmp_and_merge_page(struct page *page, struct rmap_item *rmap_item)
> > > >  {
> > > > -	struct page *page2[1];
> > > > +	struct page *page2[1] = {NULL};
> > > >  	struct rmap_item *tree_rmap_item;
> > > >  	unsigned int checksum;
> > > >  	int err;
> > > > 
> > > > 
> > > 
> > > a 1 element array looks strange, did you look what kind of magic is here used ?
> > > 
> > >From my understanding, it is used for place holder to check and return
> > an identical page from stable_tree_search(). Can we do with a double
> > indirection to struct page instead of the above? 
> > PS point me in the right direction.
> 
> I don't particularly like things like page2[1] myself, but there's
> nothing actually wrong with it, so no urgency to change it.
> 
> mm/ksm.c is under active development (better Cc the people involved
> with a sourcefile when considering changes to it), and I have a
> collection of patches under testing, which do change some names
> around here (along with more serious changes).  So, thanks for looking
> at this, but I'd prefer to avoid the interference of a trivial patch
> at the moment - sorry.
> 
> Which version of the compiler gave you that uninitialized warning?

gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux)

> A version which lots of people are using, or just some snapshot?
> I've never seen a warning there myself, but they do keep "refining"
> that logic.
> 
I got the warning while doing "make randconfig". However, now after a
cleanup and redoing the same, the warning is not seen.

> Hugh's hypothesis: for every variable x initialized by a subfunction,
> there exists at least one version V of gcc, such that V reports that
> x may be used uninitialized.
> 
> Hugh

Thanks.

