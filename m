Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbZDBQyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbZDBQyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933496AbZDBQxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:53:33 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:29502 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933284AbZDBQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:53:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=tbHLgAy3Wtq9ughsi5L63QnOt+n2kgVLf9BEb9dt/3Fjqq2/L4079hJMxSt8iukjOpyX1LC7xUwBYU5my5GzJ/WflUXx1QuqnJDZNfCBttVyxldOK/MuKtQrxpPsKSWZX+32YzSkIs1FsdkXPidalMLhuVB6U1TgXNSJbfL7/O8=  ;
X-YMail-OSG: wmpY3a0VM1m7A5a9Ffj3GvldfjpYzg1RrIem3cXRJPObBqbA.QzTSCgOUcqP56R_XXsY.it43uDQq75qkVfotpOCCBV3jCLzgiUhHbKu4YYzmPUpYA_Tlr0H3S6qSmnf11Rjxz2WGSkRQSa5t4QmAU68gJpzon.o71kP2yOedg0m.DwL9SbC2QJvb_R3HL.obeZBOKhx4KzDdia2epcltHkJmk6rU5O2fEppTxVOc1tPv9bAPZ8Z0INs5uqHnKKiqzBSmXzHHLB6BHfMeUzXs50H1lg2eF91afOKGQhUHxwWrv7MIVwo1ddiGeckeGQIOGNovEpc0iogUuvmxRKMuZCaYw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Fri, 3 Apr 2009 03:53:17 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030225.16372.nickpiggin@yahoo.com.au> <6362.1238687462@redhat.com> <200904030315.03606.nickpiggin@yahoo.com.au>
In-Reply-To: <200904030315.03606.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904030353.17713.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 03:15:02 Nick Piggin wrote:
> On Friday 03 April 2009 02:51:02 David Howells wrote:
> > Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > Possibly you can't reuse mappedtodisk....
> > 
> > PG_mappedtodisk has a very specific meaning to fs/buffer.c and fs/mpage.c.  I
> > can't also easily make it mean that a page is backed by the cache.  A page can
> > be cached and not mapped to disk.
> 
> You have 2 types of pagecache pages you are dealing with here, right? The
> netfs and the backingfs pages. From what you write above, am I to take it
> that you need to know whether a backingfs page is "backed by the cache"?
> WTF for? And what cache is it backed by if it is the backing store?

Ah, sorry you want isofs to be cached by another backing store. All
this talk of netfs confused me. Yes that's fair enough and could
put PG_mappedtodisk out of reach. OTOH, is isofs important? Enough
that it can't be done with fuse or something?

Comments about PG_private still stand.
