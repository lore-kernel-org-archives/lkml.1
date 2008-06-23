Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYFWHAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYFWHAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYFWG75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 02:59:57 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:40611 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751549AbYFWG74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 02:59:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=F4apvY7pFkDztY3BmAK/TWUa6yJrpb9DtjQf3dDNIJzAVB69INc8O7P9wnXCdgcaOpXjrvIHQz+BbpbmXgWlovOqfZvdUN1hfZpCtCKG11m3AR4YFxmDq3DjdtR1e33y34tqBUB/fYZMNO1Xj3p0wgv55zgOrGYA/n1SN12MLWo=  ;
X-YMail-OSG: vni.ZyQVM1kuYiZEBAlslUKkmpEAzikmkPau_pfFw9dSD3.shXacN.Y1CCwDZM5VzJOKUKVrFWMFKFx_F48WLRh90wGUubb3vb8x.Kk3xrohaDTe9.8BpykVpJaKiLdYmHw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops when using growisofs
Date: Mon, 23 Jun 2008 16:59:07 +1000
User-Agent: KMail/1.9.5
Cc: Michael Buesch <mb@bu3sch.de>, Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@ucw.cz>
References: <200806221818.24372.mb@bu3sch.de> <200806230028.20643.mb@bu3sch.de> <20080622233448.4b27c131.akpm@linux-foundation.org>
In-Reply-To: <20080622233448.4b27c131.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231659.07437.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 16:34, Andrew Morton wrote:
> On Mon, 23 Jun 2008 00:28:20 +0200 Michael Buesch <mb@bu3sch.de> wrote:
> > On Monday 23 June 2008 00:05:51 Michael Buesch wrote:
> > > > Note: r9 and r3 are both NULL pointers. r3 is the value returned from
> > > > alloc_page_buffers. R9 is a copy of that, which gets accessed.
> > >
> > > Hm, yeah. I looked at that code already, but I can't see how it could
> > > return a NULL pointer.
> >
> > Well, actually, it can return a NULL pointer.
> >
> >  928         head = NULL;
> >  929         offset = PAGE_SIZE;
> >  930         while ((offset -= size) >= 0) {
> > ...
> >  949         }
> >  950         return head;
> >
> > So if size, which is a passed in as parameter, is > PAGE_SIZE it will
> > return NULL.
> >
> > The size parameter is calculated by doing
> > blocksize = 1 << inode->i_blkbits;
> > in an earlier function in the callchain.
>
> Yes, that's a more likely scenario.  isofs has a history of passing
> garbage into the VFS.

Yes isofs will pass in a too-big page here (IIRC 32K or something).
And trigger this oops.
