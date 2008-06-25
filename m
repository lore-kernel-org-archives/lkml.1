Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYFYW66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYFYW66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYFYW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:58:49 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:37034 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750770AbYFYW6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:58:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KFN8ZFvFH70n3+DkubsTW9lo4+sLexleGFE14ioLFIoxYty5IQcd/PmUZgdIwapkgyzN7AlNUCJ6hmmZD/vEn1XZCjYz9EiU97E5mNK1YWXxLnrAdudty7TX06Rm6icveLW6b466eIG20lIEmvW2dQ9i9ucnlhFZPl4z9nj6s7o=  ;
X-YMail-OSG: nDjng9EVM1lmGuoDAB6CKUBQEg.IuBRVg65gsynw1TXKLtyDKQKs2MgYGW2VavJc5m_qQJucL8Eg2hgHYAwswj10Ymw6TdPTlyplkoZFZ6.cYwJFFxM1dN0vxibphh31Kzk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] rtc: remove BKL for ioctl()
Date: Wed, 25 Jun 2008 15:58:45 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200806221955.42597.david-b@pacbell.net> <20080625163928.4da1f4a0@bike.lwn.net>
In-Reply-To: <20080625163928.4da1f4a0@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251558.45809.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008, Jonathan Corbet wrote:
> On Sun, 22 Jun 2008 19:55:42 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > Remove implicit use of BKL in ioctl() from the RTC framework.
> 
> Looks good, I'll happily put it into the bkl-removal tree.

It's in MM now too ... are all the bkl-removal patches going in
at once, or will they be merged through their subsystems?


> One question, though:
> 
> > +	err = mutex_lock_interruptible(&rtc->ops_lock);
> > +	if (err)
> > +		return -EBUSY;
> > +
> 
> Shouldn't that be -EINTR?

I was just copying that usage from drivers/rtc/interface.c ...
all users there return -EBUSY.

If it's wrong in this patch it's probably wrong there too.
I suspect EINTR is the answer in all cases.

- Dave
