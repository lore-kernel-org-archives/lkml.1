Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbXE2QUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbXE2QUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXE2QUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:20:45 -0400
Received: from keil-draco.com ([216.193.185.50]:50340 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752289AbXE2QUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:20:45 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Date: Tue, 29 May 2007 12:20:38 -0400
User-Agent: KMail/1.9.6
Cc: "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       madler@alumni.caltech.edu, jloup@gzip.org
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <200705290943.11176.dhazelton@enter.net> <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
In-Reply-To: <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291220.39154.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 11:15:41 Satyam Sharma wrote:
> [ Trimmed Cc list; added original zlib authors. ]
>
> > On Tuesday 29 May 2007 09:33:51 Michael-Luke Jones wrote:
> > > On 29 May 2007, at 12:27, Satyam Sharma wrote:
> > > > Right, actually, zlib could be switched over to [using a common
> > > > directory].
> > > > Because zlib_deflate/ and zlib_inflate/ too share a private header
> > > > zutil.h which has unfortunately been stuck into include/linux/ with
> > > > a big
> > > > /* WARNING: this file should *not* be used by applications. */
> > > > comment ...
> > >
> > > Well, unfortunately zutil.h is currently being used in-kernel by fs/
> > > jffs2/compr_zlib.c despite the "WARNING: this file should *not* be
> > > used by applications" notice.
>
> Hmmm, either jffs2 thinks the zlib interfaces exposed through
> include/linux/zlib.h are insufficient, or it isn't using zlib properly
> (or at least the way it was supposed to be used :-)
>
> Looking at fs/jffs2/compr_zlib.c, however, it just seems to be
> an optimization -- skipping some checksum calculation if some
> flag (PRESET_DICT) is absent from the input stream about to
> be decompressed ...
>
> This /looks/ like an optimization that might make sense for other
> users of zlib too, in which case that entire check and
> skip-the-checksum thing could actually be put into zlib proper. (?)

This *is* a good idea. If someone doesn't beat me to it I'll make sure I've 
got the latest git and do up a patch that does this.

DRH

> > > So moving this header to a truly private location isn't possible
> > > right now, unfortunately,
> > >
> > > Michael-Luke Jones
> > > [added David Whitehouse to cc]
>
> On 5/29/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> > I've looked at that code and it seems to need that file for one constant.
> > Perhaps it'd be better for jffs2/compr_zlib.c to define that constant
> > itself (or use it as a "Magic Number") rather than include the zlib
> > private header. Another possibility would be to move that constant out of
> > zutil.h and into zconf.h or zlih.b - doing any of those would allow the
> > zlib private header to be moved such that zlib could be changed to use a
> > common directory *and* have said private header in that directory.
>
> Moving PRESET_DICT to zlib.h robs lib/zlib_deflate/deflate.c from
> being able to resolve that macro. FWIW, a dirty hack could be to
> simply duplicate it in zlib.h. But then, implementation and interface
> are decoupled for good reasons ...
>
> Satyam


