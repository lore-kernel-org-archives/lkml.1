Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbYHFRBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbYHFRBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYHFQ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:57:40 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:28573 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753852AbYHFQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:57:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zxKlsqfDuTOsENJBoVtKrHuFTauFaAeytXUikAPDrUZMZwt/661nZ6K7is6OZXqGahIMDxIfjWCUbiPff46u8JJxdRxrd1OZyf6rbD3w7T+tC0e4SjPSgZscVGbw8pPdbxQWlxmhEoEtiuWrXkd1h/C/Y6tx/by1Kk6fBhaKxoY=  ;
X-YMail-OSG: _jtUWIUVM1n7l96vjJMZVZT8ZBeH0FlvgJ6fnXp3AvcmGwAlV6Bh0wLIv6mK2.gn9LVnGIavkEu_Vraqal7YDdl.5aAWOwFt9qhuWZQiNCs5jwpHNrZ_u_Raz5sRopKemUY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: tvrtko.ursulin@sophos.com
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface =?iso-8859-1?q?for=09on_access?= scanning
Date: Thu, 7 Aug 2008 02:57:30 +1000
User-Agent: KMail/1.9.5
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
References: <20080806113028.35CD831682F@pmx1.sophos.com>
In-Reply-To: <20080806113028.35CD831682F@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070257.31097.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 21:29, tvrtko.ursulin@sophos.com wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote on 06/08/2008 12:10:58:

> > > code so what am I missing?
> >
> > Maybe... but that's not the same as what requirement 5 calls for.
>
> I see what you mean, it should have been worded better. Nevertheless that
> is what was intended by it - to enable caching only on filesystems where
> it is safe to do so.

That is exactly what you cannot do. Otherwise you have to rewrite
filesystems not to use the pagecache, and probably have to do disallow
or do some horrible hacks to support mmap.

The requirement you actually intend is more like what you said before,
along the lines of "file can't be changed in given set of circumstances".


> > But depending on exactly what semantics you really call for, it can get
> > tricky to account for all of pagecache. Writes can happen through page
> > tables or get_user_pages. True that a process has to at some point have
> > write permission to the file, but the cache itself could be modified
> > even after the file is closed and all mmaps disappear.
>
> I don't have a very good understanding of the VM subsystem I must admit.
> So in other words with the current kernel file modification time is not
> necessarily correct - it represents when the file was last opened for
> modification, not when it was actually modified? (While those two points
> in time can be arbitrarily separated)

It is a best effort thing. When you start mmapping, that allows
get_user_pages, which in turn may be able to take pages and modify
them at fairly arbitrary points in time.


> How would I use those methods for file modification? I am curious to make
> a test case..

Even just with mmap (we do a much better job of it now, but) you
can probably write to a file after mtime if you write to already
dirty pages.

