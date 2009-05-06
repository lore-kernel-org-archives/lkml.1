Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZEFFJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZEFFJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZEFFJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:09:31 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:63862 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZEFFJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:09:31 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir 
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090505233509.GG27790@fieldses.org>
References: <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl> <20090422191244.GD9541@fieldses.org> <9180.1240468823@jrobl> <20090423202705.GA31085@fieldses.org> <20090505233509.GG27790@fieldses.org>
Date: Wed, 06 May 2009 14:09:05 +0900
Message-ID: <7475.1241586545@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. Bruce Fields":
> On Thu, Apr 23, 2009 at 04:27:05PM -0400, bfields wrote:
> > On Thu, Apr 23, 2009 at 03:40:23PM +0900, hooanon05@yahoo.co.jp wrote:
> > > 
> > > "J. Bruce Fields":
> > > > > Isn't it better to test it BEFORE fh_compose()?
> > > 	:::
> > > > Yes, I think you're right.
	:::
> Err, no, I was confused, the v3 spec does clearly state that the
> filehandle field here is just an optional optimization.
> 
> But now that I look fh_compose() seems perfectly capable of dealing with
> negative dentries, so I don't think your patch is necessary after all.

I agree with you.
I just thought it is _better_ to test it BEFORE fh_compose(). I don't
think fh_compose() would crash.


If you move lookup_one_len() from nfsd4_encode_dirent_fattr() to
nfsd4_encode_dirent(), then I'd suggest you to move dput() too.
Applying your patch,
- when we get a negative dentry, nfsd4_encode_dirent() will return
  without dput(). Is it OK?
- when lookup_one_len() returns an error, nfsd4_encode_dirent() may
  crash later.


J. R. Okajima
