Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXBDM4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXBDM4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 07:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXBDM4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 07:56:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:61192 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbXBDM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 07:56:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ppiMngAbrkwozftV5G3CNOSH86XbDPDPt2mbKLkJDBmByXFuKsl8Q1n+KQITGgIFK9F7bIMslNEwm4Pa1M6Wz0HEnf3kiG8gbfWQHwWDnkhQn5mmu0KEKHxyVw52p/IZdNuGn2vl+CXXBPodM0md9XotvMNmx47m6mYN9dAeSyY=
Message-ID: <1a297b360702040455i7f1c4928waf961cd71e086ca1@mail.gmail.com>
Date: Sun, 4 Feb 2007 16:55:58 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
In-Reply-To: <20070204124819.GC12943@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070203215848.GA10440@Ahmed>
	 <20070203135951.564e5fe2.randy.dunlap@oracle.com>
	 <20070204124819.GC12943@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Feb 03, 2007 at 01:59:51PM -0800, Randy Dunlap wrote:
> > On Sat, 3 Feb 2007 23:58:48 +0200 Ahmed S. Darwish wrote:
> > >
> > > In CodingStyle Chapter 16 "Function return value and names", why not
> > > adding a comment about the favorable community way of checking the return
> > > value. ie:
> > >
> > > ret = do_method();
> > > if (ret) {
> > >    /* deal with error */
> > > }
> > >
> > > and not other ways like:
> > >
> > > if (do_method()) or if ((ret = do_method()) > value) ...
> > >
> >
> > I like it.  Please cc: Andrew Morton <akpm@osdl.org> on it.
> > Hopefully he will merge it.
> >
>
> I'm going to have to disagree.  Sometimes if the main flow of the code
> is down, it's actually better to do this:
>
>         if ((err = do_foo()) < 0)
>                 return (err);
>         if ((err = do_bar(current, filp)) < 0)
>                 return (err);
>         if ((err = do_quux(filp, buffer)) < 0) {
>                 close(filp);
>                 return (err);
>         }
>
> Than to do something like this:
>
>         err = do_foo();
>         if (err < 0)
>                 return (err);
>         err = do_bar(current, filp);
>         if (err < 0)
>                 return (err);
>         err = do_quux(filp, buffer);
>         if (err < 0) {
>                 close(filp);
>                 return (err);
>         }
>
> The first is more concise, and it draws the reader's eye to what's
> really going on.  The cleanup/return error path is less important, and
> and it's pretty clear what's going on just from glancing at it.


Completely agree, as i said in my earlier post.



manu
