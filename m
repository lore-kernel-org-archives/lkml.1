Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbXLRHDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbXLRHDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbXLRHDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:03:25 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:27651 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757537AbXLRHDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:03:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ydKBpLWjQAlG0Gw14lWJK8xdjHfK7pI6N2G/JKEx+IHyNUsi49hYXzIBVmOySuqd3sj2S6Cua6aSAozU4NQXNT97n7XZGRZoguP99SE1yvJHoCjUzW8sbObbSecRgl7pVwf7uUHmfvAI3YJIy6QN2ky7N9Av1oOCupuYJqSx7Sk=  ;
X-YMail-OSG: na.hWdYVM1mGN7jRKTS7qGYhk4beW.IdjssGfGk03kDo6b._.x.Yfoxxssh2ZuQjzIQacpks8w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/28] FS-Cache: Release page->private after failed readahead [try #2]
Date: Tue, 18 Dec 2007 18:03:13 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200712141451.56870.nickpiggin@yahoo.com.au> <20071205193904.24617.94077.stgit@warthog.procyon.org.uk> <674.1197931333@redhat.com>
In-Reply-To: <674.1197931333@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181803.14078.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 09:42, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > This is pretty nasty.
>
> Why?  If the fs doesn't set PG_private or PG_fscache on any pages before
> calling read_cache_pages(), there's no difference.

It is conceptually wrong.


> Furthermore, the differences only crop up in the error handling paths.

That doesn't make it any better.


> > I would suggest either to have the function return the number of pages
> > that were added to pagecache,
>
> Which helps how?

So the caller can do their own error handling / cleanup.


> > or just open code it.
>
> Well, I could give an alternative read_cache_pages(), I suppose, for just
> this situation, but that means there are two parallel functions which then
> both need to be maintained.

I would be OK with that.
