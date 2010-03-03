Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0CCHi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:38:56 -0500
Received: from gw1.transmode.se ([213.115.205.20]:35987 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0CCHiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:38:54 -0500
In-Reply-To: <20100302145231.5f3f0fb0.akpm@linux-foundation.org>
References: <1267373163-10841-1-git-send-email-Joakim.Tjernlund@transmode.se> <20100302145231.5f3f0fb0.akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] inflate_fast: sout is already a short so ptr arith was off
 by one.
X-KeepSent: A6036938:9580602E-C12576DB:00293497;
 type=4; name=$KeepSent
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFA6036938.9580602E-ONC12576DB.00293497-C12576DB.0029B6AE@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 3 Mar 2010 08:35:37 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-03-03 08:38:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote on 2010/03/02 23:52:31:
>
> On Sun, 28 Feb 2010 17:06:02 +0100
> Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:
>
> > This won't change anything for current code, but post increment
> > will break without this fix, should anyone want to try that.
> >
>
> The description is a bit cryptic.  Hopefully you understand what you
> mean, but does anyone else?

ehh, yes the commit msg is a bit cryptic. I can fix that.

>
> > diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
> > index fa62fc7..2c13ecc 100644
> > --- a/lib/zlib_inflate/inffast.c
> > +++ b/lib/zlib_inflate/inffast.c
> > @@ -286,7 +286,7 @@ void inflate_fast(z_streamp strm, unsigned start)
> >            } else { /* dist == 1 or dist == 2 */
> >           unsigned short pat16;
> >
> > -         pat16 = *(sout-2+2*OFF);
> > +         pat16 = *(sout-1+OFF);
> >           if (dist == 1) {
> >              union uu mm;
> >              /* copy one char pattern to both bytes */
>
> The code you're altering was changed two months ago by, err, you.  I
> don't know if the patch still makes sense in current kernels.
>
> Please don't raise patches against old kernels.  Please check that,
> redo the patch, add a changelog which helps non-inffast.c people
> understand what it does, then resend?

Not old, too new actually. You are sitting on a patch from me named
 zlib: Make new optimized inflate endian independent
that was deferred to 2.6.34.
This patch is on top of that one.

What should I do now?

   Jocke

