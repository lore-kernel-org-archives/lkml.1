Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbXHUVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbXHUVDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXHUVD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:03:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51854 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753760AbXHUVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:03:28 -0400
Date: Tue, 21 Aug 2007 14:03:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dave McCracken <dave.mccracken@oracle.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
In-Reply-To: <200708211051.36569.dave.mccracken@oracle.com>
Message-ID: <Pine.LNX.4.64.0708211400341.3082@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com> <200708211051.36569.dave.mccracken@oracle.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1839598108-1187730208=:3082"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1839598108-1187730208=:3082
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 21 Aug 2007, Dave McCracken wrote:

> On Monday 20 August 2007, Christoph Lameter wrote:
> > 1. First reclaiming non dirty pages. Dirty pages are deferred until rec=
laim
> > =A0 =A0has reestablished the high marks. Then all the dirty pages (the =
laundry)
> > =A0 =A0is written out.
>=20
> I don't buy it.  What happens when there aren't enough clean pages in the=
=20
> system to achieve the high water mark?  I'm guessing we'd get a quick OOM=
 (as=20
> observed by Peter).

We reclaim the clean pages that there are (removing the executable=20
pages from memory) and then we do writeback.

The quick OOM is due to throttling not working right AFAIK.

> > 2. Reclaim is essentially complete during the writeout phase. So we rem=
ove
> > =A0 =A0PF_MEMALLOC and allow recursive reclaim if we still run into tro=
uble
> > =A0 =A0during writeout.
>=20
> You're assuming the system is static and won't allocate new pages behind =
your=20
> back.  We could be back to critically low memory before the write happens=
=2E

Yes and that occurs now too.

> More broadly, we need to be proactive about getting dirty pages cleaned b=
efore=20
> they consume the system.  Deferring the write just makes it harder to kee=
p=20
> up.

Cleaning dirty pages through writeout consumes memory. Writing dirty pages=
=20
out early makes the memory situation even worse.

---1700579579-1839598108-1187730208=:3082--
