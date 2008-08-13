Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYHMOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYHMOIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYHMOI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:08:29 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:60477 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYHMOI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=OoyaiRL3sEp6z6UppVGr2ZrJPXPiro9beAVM15WCPw5DfEa+Wv44jR+cs6CoV4EM5S
         Otk48JODqjkKGpUKnxyzvK9va3qBr5C5eBeo9RYEgScmL3GfgqVbgQE3xqwfoKislASE
         jq+FHpzQWi3B1FHZeglJb24N7wQecs+rjcxgQ=
Message-ID: <3bc8237c0808130708w389123fet5f8d0bb6ff0429bb@mail.gmail.com>
Date: Wed, 13 Aug 2008 09:08:25 -0500
From: "Archie Cobbs" <archie@dellroad.org>
To: "Karel Zak" <kzak@redhat.com>
Subject: Re: [PATCH] losetup: add option for O_DIRECT
Cc: linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <20080813081544.GA6070@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3bc8237c0808121426m6fada313r33ed4c419386a1@mail.gmail.com>
	 <20080813081544.GA6070@nb.net.home>
X-Google-Sender-Auth: 116900ba3fe0340b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 3:15 AM, Karel Zak <kzak@redhat.com> wrote:
> On Tue, Aug 12, 2008 at 04:26:10PM -0500, Archie Cobbs wrote:
> > On Thu, Aug 7, 2008 at 1:26 PM, Archie Cobbs <archie@dellroad.org> wrote:
> > > I have an application involving the loopback device where it would be
> > > valuable for the underlying file to be opened with the O_DIRECT flag.
> > >
> > > Any thoughts one way or the other about adding support to losetup(8)
> > > and mount(8) for a 'direct' option that would enable this?
> > >
> > > I will propose a patch if people think this would be a reasonable thing to do.
> >
> > Add support for opening loopback files with O_DIRECT.
> [...]
>
> >         mode = (*options & SETLOOP_RDONLY) ? O_RDONLY : O_RDWR;
> > +       if (*options & SETLOOP_DIRECT)
> > +               mode |= O_DIRECT;
> >         if ((ffd = open(file, mode)) < 0) {
>
>
>  Do you remember  http://lkml.org/lkml/2007/1/10/233  ?

Yes... I understand there is a valid debate on the merits of O_DIRECT.
It is an interesting question and I don't claim to know the "right" answer.

For example, another way to achieve this same effect, though it would
require kernel changes, is to have some additional way(s) to configure
the loopback device using new LOOP_* ioctls.

In any case, that debate does not seem to be over yet. So my opinion:
if and when O_DIRECT is removed from Linux then we can revert this
patch too :-)

>  Sorry, but I have to see ACK/NACK from relevant kernel person.
>  Redirecting to lkml.

No problem. Please CC me on lkml responses if possible.

Thanks,
-Archie

--
Archie L. Cobbs
