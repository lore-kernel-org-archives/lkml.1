Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbYDANMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbYDANMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYDANMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:12:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:30025 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYDANMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AcFUEBj3i7ui2T9P/nUQH1kFvElY/rGiZS8bECksMJAxmk7/TdkN8Ot90aJFHlc9rr7xxxUGS5/ogU9G7i3ju93BRj2GfUQ2sji/9o5lvAXLzOhmnscZ8QQXgUwAODFLMP7jSidSEInp76pRBzhSihJJKw8uWMF6p/Shn+O6m98=
Message-ID: <84144f020804010612iec1c2d9xc9096f8cc3cd9d4d@mail.gmail.com>
Date: Tue, 1 Apr 2008 16:12:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Artem Bityutskiy" <dedekind@yandex.ru>
Subject: Re: [RFC PATCH 20/26] UBIFS: add VFS operations
Cc: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <47F22DD3.4060003@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com>
	 <84144f020804010508k3099b2bagf2f1c0d2747a983@mail.gmail.com>
	 <47F22DD3.4060003@yandex.ru>
X-Google-Sender-Auth: bfa5251697f13188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Tue, Apr 1, 2008 at 3:42 PM, Artem Bityutskiy <dedekind@yandex.ru> wrote:
> > >  +static int ubifs_releasepage(struct page *page, gfp_t unused_gfp_flags)
> > >  +{
> > >  +       /*
> > >  +        * An attempt to release a dirty page without budgeting for it - should
> > >  +        * not happen.
> > >  +        */
> > >  +       ubifs_assert(PageLocked(page));
> > >  +       if (PageWriteback(page))
> > >  +               return 0;
> > >  +       ubifs_assert(PagePrivate(page));
> > >  +       ubifs_assert(0);
> > >  +       ClearPagePrivate(page);
> > >  +       ClearPageChecked(page);
> > >  +       return 1;
> > >  +}
>
>  Yeah, this is also a guarding thing. When a dirty page is released
>  the budget which was allocated for it has to be freed. If this function
>  is called, then the budget was not freed, which must never happen.

So what guarantees that no one calls invalidate_complete_page() or
fallback_migrate_page(), for example?
