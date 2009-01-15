Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZAOGhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZAOGhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbZAOGhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:37:35 -0500
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:48019 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753986AbZAOGhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:37:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tWsLxZQdi0n0haNl9JxMZ79PB1iAMkz/9B8jc6P1SU8ylOyBhTMEkq4ZxN/vvHlo2vl7yD7zMtt/qFmfv7uuyGKeGvOgk7noNa7B9st20KB04QdcwflH0GtbB3kOcyTV6r+a8ex5rqEAbGwsxYINi8gn5XvRoM1YcvOAVxdEMok=  ;
X-YMail-OSG: 1K7lSEgVM1lSxFs6Sc_t_iySGQzZETTBZq2DsGCfKAA7kOFRF4hgx8MPTIJVAu8Uqjf9Z8vve88chxgUnSFXKMc6_yCIO6d8UaJdlrHC_DUbHAEJTjxRNaajKHr86803H8qXNmDG.UU3zDOhUBYCda41GKrGLtXSgnmxJUfEx4brKNadOKqeG.iYIH0p7yK0dKEhTKIlvrOTyX1Y1RN.mag8nM53mVmW
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29 -mm merge plans
Date: Thu, 15 Jan 2009 17:37:03 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <200901052328.26630.nickpiggin@yahoo.com.au> <20090112140606.cd6f208c.akpm@linux-foundation.org>
In-Reply-To: <20090112140606.cd6f208c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151737.03600.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009 09:06:06 Andrew Morton wrote:
> On Mon, 5 Jan 2009 23:28:26 +1100
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Monday 05 January 2009 19:43:00 Andrew Morton wrote:
> > > The individual patches are mostly at
> > > http://userweb.kernel.org/~akpm/mmotm/broken-out/
> > >
> > >
> > > mm-remove-the-might_sleep-from-lock_page.patch
> > >
> > >   Need to think about this.
> >
> > Removing this reduces a lot of might_sleep coverage scope. Page
> > lock isn't contended in a lot of cases. Why would you drop a
> > good debugging feature?
>
> For the reasons described in the changelog, of course.
>
> http://userweb.kernel.org/~akpm/mmotm/broken-out/mm-remove-the-might_sleep-
>from-lock_page.patch

Yeah, but that's because voluntary preempt is somewhat of a hack.
In fact, we recently decided to turn this off in SLES11 because it
was causing a measurable performance slowdown.

If you are actually debugging a page lock problem or writing new
code, you would be very very happy to have a problem caught here
rather than the potentially much harder task of causing a
schedule on this lock.


> > > make-sure-nobodys-leaking-resources.patch
> > > releasing-resources-with-children.patch
> >
> > Any reason why not to add these upstream?
>
> Dunno.  Are they valuable?  I've never had a report of them triggering,
> I don't think.

I don't really know the code, but if it gives extra help to
people writing or testing new devices... is it difficult to
carry around? If not, then why *not* have it upstream? ;)


> > > put_bh-debug.patch
> >
> > This could just be implemented with a VM_BUG_ON (or FS_BUG_ON) like the
> > pagecache refcounting. Wouldn't be a bad idea.
>
> yup, I guess so.  Again, no reports of it triggering in ages.

Maybe I'll go through and add some such assertions for fs developers.
fsblock is riddled with them and it really really helps catching weird
and wonderful problems in the buffer layer, the pagecache layer, or
the filesystem, or some combination of them ;) Maybe that's just
because I write a lot of bugs though!


> > > add-a-refcount-check-in-dput.patch
> >
> > Again, why not an FS_BUG_ON for things like this too?
>
> Ditto.

OK.

