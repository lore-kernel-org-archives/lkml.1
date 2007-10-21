Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbXJUKCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbXJUKCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 06:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXJUKCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 06:02:20 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:29865 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751367AbXJUKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 06:02:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Nt7huuXjv40Ogmug840GH8MDqVKCf789cI/cGd0ffxQZ8pbA2DG4OCI8gBNy8rNibCjXbm9Bg+NjiA3oYZSz2ImRVzOUDYTLqCFQQFIWtQz9u80WAB5XWxBvNEyTqQCIf7UFna5QRWIqAFL+amsfoQ/F2fHulMpna4vXQfMFVM0=  ;
X-YMail-OSG: xBBl4B0VM1nZZaUBSV_M7CkvBKIFT1vkE8baQD0mAZYlGFmt
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: BUG at mm/filemap.c:1749 (2.6.24, jffs2, unionfs)
Date: Sun, 21 Oct 2007 19:57:11 +1000
User-Agent: KMail/1.9.5
Cc: Erez Zadok <ezk@cs.sunysb.edu>, jffs-dev@axis.com,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <200710190605.l9J65kDe008069@agora.fsl.cs.sunysb.edu> <200710191716.53470.nickpiggin@yahoo.com.au> <1192956944.2672.6.camel@shinybook.infradead.org>
In-Reply-To: <1192956944.2672.6.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710211957.11928.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007 18:55, David Woodhouse wrote:
> On Fri, 2007-10-19 at 17:16 +1000, Nick Piggin wrote:
> >         if (writtenlen) {
> > -               if (inode->i_size < (pg->index << PAGE_CACHE_SHIFT) +
> > start + writtenlen) { -                       inode->i_size = (pg->index
> > << PAGE_CACHE_SHIFT) + start + writtenlen; +               if
> > (inode->i_size < pos + start + writtenlen) {
> > +                       inode->i_size = pos + start + writtenlen;
>
> This part seems wrong. Shouldn't it just be pos + writtenlen -- which is
> basically what it was already: pos==(pg->index<<PAGE_CACHE_SHIFT)+start

Yeah you're right, thanks.
