Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbXLJTwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbXLJTwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbXLJTvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:51:55 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:10268 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbXLJTvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:51:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ll9u7oVQ9xZ9NvbKLOsUkn9aer+tLbYJHdKT1HqC3WR2e3Ar02faUKOWbP/2QY0kJFY+D6Shv1Qo5dgYbljTT9bAAaeoO7k5I+Sp93hIt8z9XTQQRY0P9S9+ktxgj20rZ7QNYvBHyCwnseIHRCnpLpQiPuntstFvO+KUt+xGn+c=
Message-ID: <fa4052ef0712101151ka962076q24d1bd624f2373f5@mail.gmail.com>
Date: Mon, 10 Dec 2007 14:51:46 -0500
From: Shane <gnome42@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Cc: "Neil Brown" <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>, linux-nfs@vger.kernel.org
In-Reply-To: <200712101619.12522.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <200712090220.44543.maximlevitsky@gmail.com>
	 <18268.51342.353887.178014@notabene.brown>
	 <200712101619.12522.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 9:19 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> ...
> > It is best not to use nohide - we should probably mark it as
> > 'legacy'.
> >
> > Simply export the top level mountpoint as 'crossmnt'  and everything
> > below there will be exported.
> >
> > > Where should I put those options in root file-system export or in submount export?
> >
> > crossmnt goes at the top.  nohide goes in the submount.  Both have
> > the same general effect though with subtle differences.
> > You don't need both (though that doesn't hurt).
> > Just use crossmnt at the top,  Then you don't need to mention the
> > lower level filesystems at all.
> >
> > >
> ...
> > > (I decided to switch to NFS4 only due to the lack of ability to see underlying mounts)
> > >
> >
> > All of this should work fine with v3.  Once you have the right patch
> > for the crossmnt bug applied, if you have further problems post them
> > to linux-nfs@vger.kernel.org.
> >
> > NeilBrown
> >
>
> Big thanks,
>
> Still NFS server just don't want to accept the connection
> I noticed that if I first mount with
> -tnfs, unmount,  and then mount with -tnfs4, it works
>
>
> Assuming that
> [PATCH 2.6.24-rc4] proc: Remove/Fix proc generic d_revalidate
> is the fix for crossmnt bug, I applied it to both client and server,
> but no luck.

I'm using NFSv3, but I applied two patches. The one you mention
from Eric and the patch Trond posted in this thread.

>
> Still see empty folders.

That was the symptom I had without Trond's patch.

Shane
