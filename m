Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZF1Vpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZF1Vpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZF1Vpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:45:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34276 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbZF1Vpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:45:42 -0400
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: tridge@samba.org, john.lanza@linux.com, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <m163egw0hm.fsf@fess.ebiederm.org>
References: <19013.8005.541836.436991@samba.org>
	 <m1d48p5dil.fsf@fess.ebiederm.org> <19014.54044.484370.187018@samba.org>
	 <m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org>
	 <87ab3sx4ch.fsf@devron.myhome.or.jp> <m1k52wxhki.fsf@fess.ebiederm.org>
	 <1246219994.4190.28.camel@mulgrave.site> <m163egw0hm.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 16:45:41 -0500
Message-Id: <1246225541.4190.39.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 13:45 -0700, Eric W. Biederman wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > On Sun, 2009-06-28 at 12:51 -0700, Eric W. Biederman wrote:
> >> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> >> 
> >> > tridge@samba.org writes:
> >> >
> >> >>  > Given what you have said our interpretation of vfat has a bug,
> >> >>  > and that small change is a candidate for -stable.  If it could
> >> >>  > be it's own patch.
> >> >>
> >> >> good point. 
> >> >>
> >> >> Hirofumi-san, would you support putting the last_u change into stable?
> >> >
> >> > If you want, I have no problem to do. However, I'm not thinking that
> >> > part is a bug.  And -stable rule is also "a real bug that bothers
> >> > people", but there is even a no bug reporter which tell actual problem.
> >> 
> >> 
> >> Tridge.  Is there any reason to believe that Microsoft will continue
> >> to treat Longfilenames without short filenames as valid in vfat?
> >> 
> >> If this turns into a contest of who can do the silliest things in
> >> their vfat code microsoft could easily introduce a stricter directory
> >> parser and cause all kinds of grief.
> >> 
> >> It wouldn't even surprise me if you haven't seen such shenanigans
> >> while working on samba.
> >
> > If you own the platform, like Microsoft does, there are many things you
> > *could* do to make life difficult for others (like shipping a slightly
> > incompatible version of java, for instance ...).  However, having had
> > one or two consumer and regulatory backlashes from shipping updates
> > primarily designed to hobble what you think of as a competitor, you tend
> > to be much more wary about doing it so openly ... particularly when
> > you're trying to convince a wary customer base that you're the champion
> > of interoperability nowadays.
> >
> > The bottom line is that we need to consider the current patch on its
> > merits for evading the vfat patent.  Speculating about what Microsoft
> > might or might not do to retaliate doesn't really help with this.
> 
> This is a technical question.  Are we really in spec with the patch?

Yes, the spec is here:

http://www.microsoft.com/whdc/system/platform/firmware/fatgen.mspx

(sorry, nasty licence agreement required to read it).

It says that long filenames *may* be created without short ones (but
that if you do this you'll have backwards compatibility problems on FAT
rather than FAT32 systems, which has been explicitly noted: after this
patch you can't read created files on 8.3 FAT).

> If we are not in spec. If we break things like checkdisk.exe.   Microsoft
> can legitimately say we broke things and take technical measures to avoid
> broken filesystems.  We have dome similar things to close source binary
> modules.

The question about spec isn't really that relevant with MS ... as you
can see from the Windows XP problems, they don't follow their own
spec ... the real question is has this been tested against existing
Windows versions; the answer is Yes (see FAQ).

> My impression is that this patch puts us on the hairy edge.  If no
> one is generating files without a short filename now.  That may cause
> problems.

Only for backwards compatibility ... and IBM has explicitly checked that
according to the FAQ.  They actually found Windows XP to be out of spec
(crashed with empty short filename) which is why the patch places an
invisible string in there now.

> All else being equal this is a technically problematic patch as it
> reduces the chances of interoperability.  I am just trying to gage
> what those chances are.

So the patch has been tested with Vista, Windows 7 and Windows XP ...
I'm sure IBM would be willing to do further interop testing if you
request.

James


