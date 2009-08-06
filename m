Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZHFUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZHFUDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZHFUDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:03:18 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:18560 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625AbZHFUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:03:16 -0400
X-Trace: 242514096/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.108.240/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.108.240
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEEABDUekpQKWzw/2dsb2JhbACBUtA5hBgF
X-IronPort-AV: E=Sophos;i="4.43,336,1246834800"; 
   d="scan'208";a="242514096"
Date: Thu, 6 Aug 2009 21:03:03 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: shmem + TTM  oops
In-Reply-To: <4A7ACC90.2000808@tungstengraphics.com>
Message-ID: <Pine.LNX.4.64.0908062045270.944@sister.anvils>
References: <4A7ACC90.2000808@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-70471242-1249588983=:944"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-70471242-1249588983=:944
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 6 Aug 2009, Thomas Hellstr=C3=B6m wrote:
> Hi!
> I've been debugging a strange problem for a while, and it'd be nice to ha=
ve
> some more eyes on this.
>=20
> When the TTM graphics memory manager decides it's using too much memory, =
it
> copies the contents of the buffer to shmem objects and releases the buffe=
rs.
> This is because shmem objects are pageable whereas TTM buffers are not. W=
hen
> the TTM buffers are accessed in one way or another, it copies contents ba=
ck.
> Seems to work fairly nice, but not really optimal.
>=20
> When the X server is VT switched, TTM optionally switches out all buffers=
 to
> shmem objects, but when the contents are read back, some shmem objects ha=
ve
> corrupted swap entry top directory. The member
> shmem_inode_info::i_indirect[0] usually contains a value 0xffffff60 or
> something similar, causing an oops in shmem_truncate_range() when the shm=
em
> object is freed. Before that, readback seems to work OK. The corruption i=
s
> happening after X server VT switch when TTM is supposed to be idle. The s=
hmem
> objects have been verified to have swap entry directories after all buffe=
r
> objects have been swapped out.

Not a symptom I've ever come across: I agree strange.  A few questions:

What architecture? I assume x86 32-bit; if so, what happens on 64-bit?
if not x86, what is your PAGE_SIZE?

What size are these objects i.e. how many pages?

What release? I'm assuming 2.6.31-rc5 and various earlier.

What slab allocator? what if you choose another (SLUB versus SLAB)?
Please turn on all the slab/slub debugging you can.

And you say i_indirect "usually contains a value 0xffffff60 or something
similar": please give other examples of what you find there (if possible,
with a rough idea of their frequency e.g. is 0xffffff60 the most common?).

Does there appear to be corruption of any other nearby fields?

Thanks.

>=20
> If anyone could shed some light over this, it would be very helpful. Rele=
vant
> TTM code is fairly straightforward looks like this. The process that copi=
es
> out to shmem objects may not be the same process that copies in:

I didn't notice anything wrong with your code; and it wouldn't
be easy for it to corrupt that field of shmem_inode_info.

Hugh
--8323584-70471242-1249588983=:944--
