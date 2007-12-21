Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbXLUBMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbXLUBMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbXLUBMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:12:41 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:29419 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754729AbXLUBMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:12:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=32RQm5eAFXpTvdqJSZ04fqZfT86Ttt+taBjO8tm+XKXQwjt2erQnBFgUsZOSVvzNkUBggSRqe0K4bY31X1wUTaG/6t1ZWar1AbjrOsdcAzqOEZFtAgMZ2S3G1Bacy16cp1nb0CvK0RKXhlbuOs4B+x7oeiX+2R+J7WUsrUqazRg=  ;
X-YMail-OSG: b5bguC4VM1lQT86JbVJGliiKnKjBFQF90I2L68AAGNtwLxQosh1WltZvNTpQBakTwqbyLhs3dg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/28] AFS: Add a function to excise a rejected write from the pagecache [try #2]
Date: Fri, 21 Dec 2007 12:11:14 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200712181807.53907.nickpiggin@yahoo.com.au> <731.1197932071@redhat.com> <6538.1198176550@redhat.com>
In-Reply-To: <6538.1198176550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712211211.14783.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 05:49, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > This reintroduces the fault vs truncate race window, which must be
> > > > fixed.
> > >
> > > Hmmm...  perhaps.
> >
> > What do you mean by perhaps?
>
> I mean 'perhaps'.  I'm not sure I remember what the race was, so I can't
> evaluate whether or not the same race crops up in AFS too.  So: can you
> describe the race please.

It's in the changelogs.


> > No, you could do writeback caching but disallow read of dirty data.
>
> Someone might already have read-access via mmap at the point someone
> attempts to write to an mmapped region.  That means that I'd have to revoke
> the read access of the first someone before letting the write take place.
>
> Does NFS do this?

I don't know. But yeah I guess it's tricky. Still, if I was writing a
filesystem, I'd focus on behavioural niceness/correctness above
performance, but maybe that's not realistic.


> > > > But otherwise I guess if you really want to discard the dirty data
> > > > after a failed writeback attempt, what's wrong with just
> > > > invalidate_inode_pages2?
> > >
> > > Erm...  Because it deadlocks?
> >
> > Why don't you call it after calling end_page_writeback?
>
> Because then there can be a race over who gets to flush the dead write.

You should solve it in your filesystem.


> Actually, this may no longer be a problem with your write_begin() changes.
> I'll need to have another look at those.
>
> Besides, I don't agree that invalidate_inode_pages2() is necessarily the
> right way to do things.

Why?
