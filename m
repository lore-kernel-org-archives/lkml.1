Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbXLRHAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbXLRHAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbXLRHAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:00:36 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:48126 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756167AbXLRHAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:00:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dP5Lg5h4tKjCY2wniHJnkB/PELBb8mUiBLjbDLnGaAaQZbkBJxLri+injAA2xCmDSFBjk5CMXqkJyxdqqYRZVOnIUPpMQXXuCXarq1BVThE4jBLoXi9ww5yrQPG4rLZ+8jB5Lg0+yaaX0rJAGsp4J+k76gkNhMDvJci42Ul3oGA=  ;
X-YMail-OSG: AXOoyncVM1miH4qo0OKIYKYrEVnLyLJjV63j4xFHMYu3onvLRrn0JosRLtxBICykElBczZPogA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
Date: Tue, 18 Dec 2007 18:00:23 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200712141508.23756.nickpiggin@yahoo.com.au> <20071205193909.24617.26538.stgit@warthog.procyon.org.uk> <643.1197930966@redhat.com>
In-Reply-To: <643.1197930966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181800.23578.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 09:36, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > I'd much prefer if you would handle this in the filesystem, and have it
> > set PG_private whenever fscache needs to receive a callback, and DTRT
> > depending on whether PG_fscache etc. is set or not.
>
> That's tricky and slower[*].  One of the things I want to do is to modify
> iso9660 to do be able to do caching, but PG_private is 'owned' by the
> generic buffer cache code.

Maybe it is harder, but it is the right way to do it. So you
should modify the filesystems rather than core code.
