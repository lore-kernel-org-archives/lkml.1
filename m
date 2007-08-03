Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbXHCQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbXHCQxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXHCQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:53:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:19174 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbXHCQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XKxo3R3SgL4E+w9DELy7ofRKrzyGrClVSlhRJpzj3dcikAQtsBndcHo8MXs1DOpPLJPRc2wOVne9ilaJbtUCZQR/SHpAVqgzKF2sDVRVGRLiQ6UvmEwqnMdoFXg3tTEohzulTqVVerasp47SLkHDC9sO0bNo+VFuXsBAby18jME=
Message-ID: <29495f1d0708030953q7767ea77jec641e53cfe04944@mail.gmail.com>
Date: Fri, 3 Aug 2007 09:53:10 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Adam Litke" <agl@us.ibm.com>
Subject: Re: [PATCH] remove hugetlb_instantiation_mutex
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1186159163.23817.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185523069.4688.115.camel@ymzhang>
	 <1185554277.23817.18.camel@localhost.localdomain>
	 <1185779758.4688.177.camel@ymzhang>
	 <1186159163.23817.32.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/07, Adam Litke <agl@us.ibm.com> wrote:
> On Mon, 2007-07-30 at 15:15 +0800, Zhang, Yanmin wrote:
> > On Fri, 2007-07-27 at 11:37 -0500, Adam Litke wrote:
> > > Hey... I am amazed at how quickly you came back with a patch for this :)
> > > Thanks for looking at it.  Unfortunately there is one show-stopper and I
> > > have some reservations (pun definitely intended) with your approach:
> > Thanks for your great comments.
>
> Sorry for such a long delay in responding.  I have been pretty busy
> lately.
>
> > > First, your patch does not pass the libhugetlbfs test
> > > 'alloc-instantiate-race' which was written to tickle the the race which
> > > the mutex was introduced to solve.  Your patch works for shared
> > > mappings, but not for the private case.
> > My testing about private might not be thorough. Function hugetlb_cow has a race
> > for multi-thread to fault on the same private page index. But after I fixed it,
> > alloc-instantiate-race still failed.
> >
> > I tried to google the source code tarball of libhugetlbfs test suite, but couldn't
> > find it. Would you like to send me a copy of the test source codes?
>
> http://libhugetlbfs.ozlabs.org/releases/libhugetlbfs-1.2-pre1.tar.gz
>
> The tarball will contain a test called alloc-instantiate-race.  Make
> sure to run it in private and shared mode.  Let me know what you find
> out.

Actually, please use
http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20070718.tar.gz.
1.2-pre1 had a build error that is fixed in the development snapshot.

Thanks,
Nish
