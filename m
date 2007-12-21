Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXLUBJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXLUBJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXLUBJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:09:26 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:45683 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753490AbXLUBJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:09:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=O3n798pwUsWBzgCyFr2vQUH0GpMK2vDdu/625fxU5HyycOG1fpV+vpn3Lbqhm3eE0dVo8jNW7TMJtRz49pnofk3PbY7FgC4TiRtw9Z34F5s+EE3Nry7s/Pb65vGKrVOrEFQh73y51HWyTQMSEOVUkuve9AUYMdfoWQpdDtXom4A=  ;
X-YMail-OSG: UzdadgkVM1mXuUaGuuU.FnyuXfkEydwTUHodKgs3QmEF7u29lFoo6374JF.SsXWBYMNzO2C5iA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
Date: Fri, 21 Dec 2007 12:08:23 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200712181800.23578.nickpiggin@yahoo.com.au> <643.1197930966@redhat.com> <6481.1198175619@redhat.com>
In-Reply-To: <6481.1198175619@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712211208.24026.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 05:33, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > I'd much prefer if you would handle this in the filesystem, and have
> > > > it set PG_private whenever fscache needs to receive a callback, and
> > > > DTRT depending on whether PG_fscache etc. is set or not.
> > >
> > > That's tricky and slower[*].  One of the things I want to do is to
> > > modify iso9660 to do be able to do caching, but PG_private is 'owned'
> > > by the generic buffer cache code.
> >
> > Maybe it is harder, but it is the right way to do it.
>
> You're wrong.  It would mean that PG_private is the logical disjunction of
> PG_fscache and some condition not otherwise explicitly stored.  I tried
> that with NFS and it was nasty.
>
> As you can no doubt see, it means that you can't distinguish all the states
> you used to be able to.
>
> > So you should modify the filesystems rather than core code.
>
> I think you missed what I said:
>
> 	but PG_private is 'owned' by the generic buffer cache code.
>
> That means more of the core code would have to change - or, at least,
> change more.

Then make a PG_private2 bit and use that.

