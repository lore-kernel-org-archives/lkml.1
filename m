Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYKCDEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYKCDEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 22:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYKCDE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 22:04:29 -0500
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:27038 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754224AbYKCDE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 22:04:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CapkLVblaeeIe4j3fsVEcxwpN8ekq6HDUuvSF+4lpLm7Pug8yBV+y5YZR2coj35ykpzN9URrmlPs0P3vZAkFJSdbkkN+8Znt+lE+uo8koGoR8Vr0hVKpIx5Rie7rBTODHbOGHucKi5ym2ZwBItmgva8NJtRzi9g+TjWKq0WzDhI=  ;
X-YMail-OSG: 9STrtMwVM1lxivr3feL9lRLKA5fLwC4ql.SCTsJk8a2moqSJRtyE_hUWYvWOkNfvmN.fmy9WauNMZ9Bj31ExVg0sqWkEsnLZtZGANjdFR6IqMEpDEpoRn11FqeD3JvH6PkwXNs_vhQnYU.c4aSY7y5j0DxkEm2L.EipmOGd9OZeTwgjCK8UZ4c4LFV0X
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Fri, 31 Oct 2008 20:47:20 +1100
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>, Arthur Jones <ajones@riverbed.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       sct@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081029210949.GA27274@mit.edu> <4909B8D6.7070206@redhat.com>
In-Reply-To: <4909B8D6.7070206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810312047.20306.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2008 00:38, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Wed, Oct 29, 2008 at 03:36:33PM -0500, Eric Sandeen wrote:
> >> Sorry for the silence, this is a nice bug you've found :)
> >>
> >> I'll look into it ...
> >
> > You may want to take a quick look at this thread:
> >
> >     http://lkml.org/lkml/2008/10/28/413
> >
> > 					- Ted
>
> I thought about that, but at least at first glance I don't see how the
> gfp mask change would cause this behavior...?  At least, I don't think
> we're seeing recursion back into the filesystem... but I'll ponder that.

That's definitely a bug which I'll have to fix for 2.6.28, but
I agree it's unlikely to recurse frequently like this (would only
happen under high memory pressure, and only when writeout from
page reclaim happens).


> (Also, Arthur reports seeing this as long ago as 2.6.9...)

OK, well that would confirm it.
