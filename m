Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYKSOoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYKSOoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYKSOno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:43:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:5004 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYKSOnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=X+jC2UGy0qdYxqHu4H3fj6Gl3/cZjY46Ta/fSjCg84J0Ao3Ba6Y6HxFC2V+ef53tdh
         RrM10iJkfdIM5oCm5IP7FMh0Z/LZF3LOLkkqkllfpTApvTxGOuJdfZEpp4rVOEduEuxy
         jim+mGQKa2VKXWXabfbtgmspUk+yTb5uvd3Tg=
Message-ID: <cfd18e0f0811190643j7769f768q53889bbc950ef251@mail.gmail.com>
Date: Wed, 19 Nov 2008 09:43:41 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [take 3] Use pid in inotify events.
Cc: "Christoph Hellwig" <hch@lst.de>, "Robert Love" <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, john@johnmccutchan.com
In-Reply-To: <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <20081116232450.GA13547@ioremap.net>
	 <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
	 <20081118131937.GC16944@lst.de> <20081119140500.GA25968@ioremap.net>
	 <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RESENT, because LKML bounced some HTML that accidentally got put in the mail.]
[CC+=John McCutchan, this time with hopefully a live email address;
John, some context here: http://marc.info/?t=122633022400003&r=1&w=2 ]

Evgeniy,

On Wed, Nov 19, 2008 at 9:05 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
>
> Hi Christoph.
>
> On Tue, Nov 18, 2008 at 02:19:37PM +0100, Christoph Hellwig (hch@lst.de) wrote:
> > Yes, this kind of thing should be enable using an flag to inotify1, and
> > be consistant even for rename.  Doing it as a flag to inotify1 also has
> > the advantage to be able to return an -EPERM when the feature is
> > requested but not allowed instead of letting applications that assume it
> > silently fail.
>
> So effectively you propose to have second generation of the inotify
> which will have additional pid field, which will be unused by all but
> the same uid events?

I suspect that Christoph wants the same thing as I do: some thinking
towards a future-proof design, rather than a quick hack to address the
needs of a single application.

> If you want to return -EPERM, than it will be _always_ returned for non
> sysadmin capable user, which effectively makes it unusable.

Again, appropriate flags in inotify_init1() could fix this -- e.g.,
only fill the field (and give an error if no perms) if a flag is set.

I think what is really needed at this point is some consideration of
what other extensions (if any) might be desired for inotify, and how
we might be best create a design that suits those and future needs.

Cheers,

Michael


--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
