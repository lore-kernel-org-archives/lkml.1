Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbYDAMIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbYDAMIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYDAMIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:08:38 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:17166 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYDAMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JEUDBqfxtUd0awB57urM2vVKoVkfnwkQgZdSOC08uhsAUXDMfxWrAHQnCjafj24tO6O5Py9nN3MFDW5yQQNVi0Z3QfPFw3SlmikjpojIk1KNcLKkKfJvxo6OspDGO7XFCjLlvrkKuC2zLm4QtYldqEEmh/0Twbbc+Uqfugy5pRc=
Message-ID: <84144f020804010508k3099b2bagf2f1c0d2747a983@mail.gmail.com>
Date: Tue, 1 Apr 2008 15:08:36 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: Re: [RFC PATCH 20/26] UBIFS: add VFS operations
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com>
X-Google-Sender-Auth: dbb618f8e980aed2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Thu, Mar 27, 2008 at 5:55 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
>  +static int ubifs_set_page_dirty(struct page *page)
>  +{
>  +       /*
>  +        * An attempt to dirty a page without budgeting for it - should not
>  +        * happen.
>  +        */
>  +       ubifs_assert(0);
>  +       return __set_page_dirty_nobuffers(page);
>  +}
>  +
>  +static int ubifs_releasepage(struct page *page, gfp_t unused_gfp_flags)
>  +{
>  +       /*
>  +        * An attempt to release a dirty page without budgeting for it - should
>  +        * not happen.
>  +        */
>  +       ubifs_assert(PageLocked(page));
>  +       if (PageWriteback(page))
>  +               return 0;
>  +       ubifs_assert(PagePrivate(page));
>  +       ubifs_assert(0);
>  +       ClearPagePrivate(page);
>  +       ClearPageChecked(page);
>  +       return 1;
>  +}

So you don't expect the VM to ever call these functions? Why?

                        Pekka
