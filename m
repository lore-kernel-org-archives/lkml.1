Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYBEARM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYBEARM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbYBEAQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:16:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756296AbYBEAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:16:58 -0500
Date: Mon, 4 Feb 2008 16:16:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: yi.y.yang@intel.com, greg@kroah.com, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1: module params broken
Message-Id: <20080204161620.6230f62a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802042357470.4513@blonde.site>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802042140250.8210@blonde.site>
	<20080204150638.512f46ea.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802042357470.4513@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 00:06:39 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> On Mon, 4 Feb 2008, Andrew Morton wrote:
> > 
> > Takashi found a bug in it:
> 
> Bless him.
> 
> > --- a/lib/vsprintf.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2
> > +++ a/lib/vsprintf.c
> > @@ -234,7 +234,7 @@ int strict_strto##type(const char *cp, u
> >  		if (ret != 0)						\
> >  			*res = -(*res);					\
> >  	} else								\
> > -		ret = strict_strtou##type(cp+1, base, res);		\
> > +		ret = strict_strtou##type(cp, base, res);		\
> >  									\
> >  	return ret;							\
> >  }									\
> > _
> > 
> > and I was very bad and didn't immediately prepare and upload the fix and
> > hence probably wasted a lot of your time, for which I apologise.  In my
> > defense, it was 4:00AM Sunday and I had lost eye control by then.
> 
> Please don't even begin to think of apologizing to me:
> that's so much the wrong way round it's embarrassing.

three minutes saved here led to maybe an hour lost there.

> It's scary to think of how much of your time gets wasted
> on knocking these -mms into some kind of shape that's
> then ready for the rest of us to start attacking them.

Well yeah.  Three minutes saved there (* 1000) led to maybe 1000 hours lost
here.  Kernel economics :(


> > Does that fix fix it?  If not: patch overboard.
> 
> Reprieve!  Indeed that precisely fixes it: numerous
> modules now working again with that fix.  Thanks a lot.

Thanks.
